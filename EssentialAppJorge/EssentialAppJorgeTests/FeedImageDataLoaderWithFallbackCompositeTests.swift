//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 17/11/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - Class FeedImageDataLoaderWithFallbackComposite
class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoaderProtocol {
    private class Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    
    init(primary: FeedImageDataLoaderProtocol, fallback: FeedImageDataLoaderProtocol) {
        
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        return Task()
    }
}


// MARK: - Class FeedImageDataLoaderWithFallbackCompositeTests
class FeedImageDataLoaderWithFallbackCompositeTests: XCTest {
    func test_init_doesNotLoadImageData() {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        
        _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    
    // MARK: - Helpers
    private class LoaderSpy: FeedImageDataLoaderProtocol {
        private var messages = [(url: URL, completion: (FeedImageDataLoaderProtocol.Result) -> Void)]()
        var loadedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }
        
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
            return Task()
        }
    }
}
