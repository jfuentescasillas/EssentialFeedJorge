//
//  SceneDelegate.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 16/11/23.
//


import UIKit
import EssentialFeedJorge
import EssentialFeedJorgeiOS
import CoreData
import Combine


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var httpClient: HTTPClientProtocol = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStoreProtocol & FeedImageDataStoreProtocol = {
        try! CoreDataFeedStore(storeURL: NSPersistentContainer
            .defaultDirectoryURL()
            .appending(path:"feed-store.sqlite"))
    }()
    
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var remoteFeedLoader = {
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        return RemoteLoader(url: url, client: httpClient, mapper: FeedItemsMapper.map)
    }()
                      
                      
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
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeLocalImageLoaderWithRemoteFallback))
        
        window?.makeKeyAndVisible()
    }
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoaderProtocol.Publisher {
        return remoteFeedLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoaderProtocol.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url)
            })
    }
}


// MRAK: - Extension. RemoteLoader
extension RemoteLoader: FeedLoaderProtocol where Resource == [FeedImage] {}
