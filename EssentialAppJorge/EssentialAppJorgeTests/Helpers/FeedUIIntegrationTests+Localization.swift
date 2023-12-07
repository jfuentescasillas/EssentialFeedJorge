//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 19/09/23.
//


import Foundation
import XCTest
import EssentialFeedJorge


extension FeedUIIntegrationTests {
    private class DummyView: ResourceViewProtocol {
        func display(_ viewModel: Any) {}
    }
    
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    
    var feedTitle: String {
        FeedPresenter.title
    }
}
