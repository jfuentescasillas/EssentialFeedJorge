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


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")
    private lazy var httpClient: HTTPClientProtocol = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStoreProtocol & FeedImageDataStoreProtocol = {
        try! CoreDataFeedStore(storeURL: localStoreURL)
    }()
    
    
    convenience init(httpClient: HTTPClientProtocol, store: FeedStoreProtocol & FeedImageDataStoreProtocol) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
                
        configWindow()
    }
    
    
    func configWindow() {
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
                      
        let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
                feedLoader: FeedLoaderWithFallbackComposite(
                    primary: FeedLoaderCacheDecorator(
                        decoratee: remoteFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader),
                imageLoader: FeedImageDataLoaderWithFallbackComposite(
                    primary: localImageLoader,
                    fallback: FeedImageDataLoaderCacheDecorator(
                        decoratee: remoteImageLoader,
                        cache: localImageLoader)))
        )
    }
    
    
    func makeRemoteClient() -> HTTPClientProtocol {
        return httpClient
    }
}
