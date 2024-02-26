//
//  SceneDelegate.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 16/11/23.
//


import os
import UIKit
import EssentialFeedJorge
import EssentialFeedJorgeiOS
import CoreData
import Combine


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    private lazy var httpClient: HTTPClientProtocol = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var logger = Logger(subsystem: "com.essentialdeveloper.EssentialAppCaseStudy", category: "main")
    private lazy var store: FeedStoreProtocol & FeedImageDataStoreProtocol = {
        do {
            return try CoreDataFeedStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("feed-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            
            return NullStore()
        }
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: showComments)
    )
    
    
    convenience init(httpClient: HTTPClientProtocol, store: FeedStoreProtocol & FeedImageDataStoreProtocol) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        configWindow()
    }
    
    
    func configWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    
    private func showComments(for image: FeedImage) {
        let url = ImageCommentsEndpoint.get(image.id).url(baseURL: baseURL)
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
        navigationController.pushViewController(comments, animated: true)
    }
    
    
    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        let publisher = { [httpClient] in
            return httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
        
        return publisher
    }
    
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        let publisher = makeRemoteFeedLoader()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map(makeFirstPage)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    
    private func makeRemoteLoadMoreLoader(last: FeedImage?) -> AnyPublisher<Paginated<FeedImage>, Error> {
        let publisher = localFeedLoader.loadPublisher()
            .zip(makeRemoteFeedLoader(after: last))
            .map { (cachedItems, newItems) in
                (cachedItems + newItems, newItems.last)
            }.map(makePage)
            .caching(to: localFeedLoader)
        
        return publisher
    }
    
    
    private func makeRemoteFeedLoader(after: FeedImage? = nil) -> AnyPublisher<[FeedImage], Error> {
        let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)
        let publisher = httpClient
            .getPublisher(url: url)
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    
    private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
        return makePage(items: items, last: items.last)
    }
    
    
    private func makePage(items: [FeedImage], last: FeedImage?) -> Paginated<FeedImage> {
        let paginated = Paginated(items: items, loadMorePublisher: last.map { last in
            { self.makeRemoteLoadMoreLoader(last: last) }
        })
        
        return paginated
    }
    
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoaderProtocol.Publisher {
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient] in
                httpClient
                    .getPublisher(url: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
}


/*  // Code used in Logging, Profiling, and Optimizing Infrastructure Services
 private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoaderProtocol.Publisher {
     let localImageLoader = LocalFeedImageDataLoader(store: store)
     
     return localImageLoader
         .loadImageDataPublisher(from: url)
         .logCacheMisses(url: url, logger: logger)
         .fallback(to: { [httpClient, logger] in
             httpClient
                 .getPublisher(url: url)
                 .logError(url: url, logger: logger)
                 .logElapsedTime(url: url, logger: logger)
                 .tryMap(FeedImageDataMapper.map)
                 .caching(to: localImageLoader, using: url)
         })
 }
}


// MARK: - Extension. Publisher
extension Publisher {
 func logCacheMisses(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
     let publisher = handleEvents(
         receiveCompletion: { result in
             if case .failure = result {
                 logger.trace("Cache miss for url: \(url)")
             }
         }).eraseToAnyPublisher()
     
     return publisher
 }
 
 
 func logError(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
     let publisher = handleEvents(
         receiveCompletion: { result in
             if case let .failure(error) = result {
                 logger.trace("Failed to load url: \(url) with error: \(error.localizedDescription)")
             }
         }).eraseToAnyPublisher()
     
     return publisher
 }
 
 
 func logElapsedTime(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
     var startTime = CACurrentMediaTime()
     let publisher = handleEvents(
         receiveSubscription: { _ in
             logger.trace("Started loading url: \(url)")
             startTime = CACurrentMediaTime ()
         },
         receiveCompletion: { result in
             let elapsed = CACurrentMediaTime() - startTime
             logger.trace("Finished loading url: \(url) in \(elapsed) seconds")
         }).eraseToAnyPublisher()
     
     return publisher
 }
}
 */
