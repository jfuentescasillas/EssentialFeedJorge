//
//  FeedPresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 11/10/23.
//

import Foundation


// MARK: - FeedPresenter class
public final class FeedPresenter {
    public static var title: String {
        let localizedString = NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
        
        return localizedString
    }
    
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
