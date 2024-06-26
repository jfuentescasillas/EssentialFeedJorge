//
//  FeedCacheTestsHelpers.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 21/08/23.
//


import Foundation
import EssentialFeedJorge


// MARK: - Method helpers
func uniqueImage() -> FeedImage {
    let image = FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    
    return image
}


func uniqueImageFeed() -> (models: [FeedImage], locals: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let localItems = models.map { LocalFeedImage(id: $0.id, description: $0.description,
                                                 location: $0.location, url: $0.url) }
    
    return (models, localItems)
}


// MARK: - Extension. Date. Days
extension Date {
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
}
