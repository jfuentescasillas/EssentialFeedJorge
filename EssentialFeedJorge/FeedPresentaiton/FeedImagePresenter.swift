
//
//  FeedImagePresenter.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 11/10/23.
//


import Foundation


public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}
