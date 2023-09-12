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
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
       
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    
    class LoaderSpy: FeedLoaderProtocol {
        private(set) var loadCallCount: Int = 0
        
        
        func load(completion: @escaping (EssentialFeedJorge.LoadFeedResult) -> Void) {
            loadCallCount += 1
        }
    }
}
