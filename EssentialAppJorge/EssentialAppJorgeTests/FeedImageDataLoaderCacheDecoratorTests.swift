//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 21/11/23.
//


import XCTest
import EssentialFeedJorge
import EssentialAppJorge


// MARK: - Class FeedImageDataLoaderCacheDecorator
class FeedImageDataLoaderCacheDecorator: FeedImageDataLoaderProtocol {
    private let decoratee: FeedImageDataLoaderProtocol
    
    
    init(decoratee: FeedImageDataLoaderProtocol) {
        self.decoratee = decoratee
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}


// MARK: - Class FeedImageDataLoaderCacheDecoratorTests
class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loader URLs")
    }
    
    
    func test_loadImageData_loadsFromLoader() {
        let url = anyURL()
        let (sut, loader) = makeSUT()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }
    
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let url = anyURL()
        let (sut, loader) = makeSUT()
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(loader.cancelledURLS, [url], "Expected to cancel URL loading from loader")
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderProtocol, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    
    private class LoaderSpy: FeedImageDataLoaderProtocol {
        private var messages = [(url: URL, completion: (FeedImageDataLoaderProtocol.Result) -> Void)]()
        private(set) var cancelledURLS = [URL]()
        var loadedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        
        private struct Task: FeedImageDataLoaderTask {
            let callback: () -> Void
            
            
            func cancel() { callback() }
        }
        
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            
            let task = Task { [weak self] in
                guard let self else { return }
                
                self.cancelledURLS.append(url)
            }
            
            return task
        }
    }
}
