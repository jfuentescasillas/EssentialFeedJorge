//
//  FeedUIComposer.swift
//  EssentialFeedJorgeiOS
//
//  Created by jfuentescasillas on 15/09/23.
//


import UIKit
import EssentialFeedJorge


// MARK: - FeedUIComposer Class
public final class FeedUIComposer {
    private init() {}
    
    
    public static func feedComposedWith(feedLoader: FeedLoaderProtocol, imageLoader: FeedImageDataLoaderProtocol) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)
        
        presentationAdapter.presenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(feedController),
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
            )
        )
        
        return feedController
    }
}


// MARK: - Extension. FeedViewController
private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        
        return feedController
    }
}
