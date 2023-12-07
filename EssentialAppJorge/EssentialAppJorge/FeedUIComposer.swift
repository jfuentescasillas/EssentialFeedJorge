//
//  FeedUIComposer.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit
import EssentialFeedJorge
import EssentialFeedJorgeiOS
import Combine


// MARK: - FeedUIComposer Class
public final class FeedUIComposer {
    private init() {}
    
    
    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoaderProtocol.Publisher) -> FeedViewController {
            let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader: feedLoader)
            let feedController = makeFeedViewController(delegate: presentationAdapter, title: FeedPresenter.title)
            
            presentationAdapter.presenter = LoadResourcePresenter(
                resourceView: FeedViewAdapter(
                    controller: feedController,
                    imageLoader: imageLoader),
                loadingView: WeakRefVirtualProxy(feedController),
                errorView: WeakRefVirtualProxy(feedController),
                mapper: FeedPresenter.map)
            
            return feedController
        }
    
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        
        return feedController
    }
}
