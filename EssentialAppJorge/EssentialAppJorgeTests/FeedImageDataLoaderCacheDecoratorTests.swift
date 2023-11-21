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
class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCaseProtocol {
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
    
    
    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let imageData = anyData()
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .success(imageData), when: {
            loader.complete(with: imageData)
        })
    }
    
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderProtocol, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
}
