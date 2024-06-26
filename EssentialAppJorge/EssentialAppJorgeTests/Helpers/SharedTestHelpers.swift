//
//  SharedTestHelpers.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 17/11/23.
//


import Foundation
import EssentialFeedJorge


func anyData() -> Data {
    return Data("any data".utf8)
}


func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}


func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}


func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}


private class DummyView: ResourceViewProtocol {
    func display(_ viewModel: Any) {}
}


var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}
