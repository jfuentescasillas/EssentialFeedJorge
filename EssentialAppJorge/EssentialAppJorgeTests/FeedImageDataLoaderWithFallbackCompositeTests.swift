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
    private let primary: FeedImageDataLoaderProtocol

    
    init(primary: FeedImageDataLoaderProtocol, fallback: FeedImageDataLoaderProtocol) {
        self.primary = primary
    }
    
    
    private class Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        _ = primary.loadImageData(from: url) { _ in }
        
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
    
    
    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let url = anyURL()
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }


    // MARK: - Helpers
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }
    
    
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
