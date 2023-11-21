//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 21/11/23.
//


import XCTest
import EssentialFeedJorge
import EssentialAppJorge


// MARK: - FeedImageDataCacheProtocol
protocol FeedImageDataCacheProtocol {
    typealias Result = Swift.Result<Void, Error>
    
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}


// MARK: - Class FeedImageDataLoaderCacheDecorator
class FeedImageDataLoaderCacheDecorator: FeedImageDataLoaderProtocol {
    private let decoratee: FeedImageDataLoaderProtocol
    private let cache: FeedImageDataCacheProtocol
    
    
    init(decoratee: FeedImageDataLoaderProtocol, cache: FeedImageDataCacheProtocol) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        let decorateeWithLoadImageData = decoratee.loadImageData(from: url) { [weak self] result in
            guard let self else { return }
            
            self.cache.save((try? result.get()) ?? Data(), for: url) { _ in }
            completion(result)
        }
        
        return decorateeWithLoadImageData
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
    
    
    func test_loadImageData_cachesLoadedDataOnLoaderSuccess() {
        let cache = CacheSpy()
    }
    
    
    // MARK: - Helpers
    private func makeSUT(cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderProtocol, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    
    private class CacheSpy: FeedImageDataCacheProtocol {
        private(set) var messages = [Message]()
        
        
        enum Message: Equatable {
            case save(data: Data, for: URL)
        }
        
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCacheProtocol.Result) -> Void) {
            messages.append(.save(data: data, for: url))
            completion(.success(()))
        }
    }
}
