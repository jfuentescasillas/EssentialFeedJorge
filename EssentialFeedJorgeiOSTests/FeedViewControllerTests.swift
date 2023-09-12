//
//  FeedViewControllerTests.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 12/09/23.
//


import XCTest
import UIKit
import EssentialFeedJorge


final class FeedViewController: UIViewController {
    private var loader: FeedLoaderProtocol?
    
    
    convenience init(loader: FeedLoaderProtocol) {
        self.init()
        self.loader = loader
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}


final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    
    // MARK: - Helpers
    class LoaderSpy: FeedLoaderProtocol {
         private(set) var loadCallCount: Int = 0
        
        
        func load(completion: @escaping (EssentialFeedJorge.LoadFeedResult) -> Void) {
            loadCallCount += 1
        }
    }
}
