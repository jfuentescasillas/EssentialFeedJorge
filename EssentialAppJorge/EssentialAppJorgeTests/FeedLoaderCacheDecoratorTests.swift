//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 20/11/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - Protocol
protocol FeedCacheProtocol {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}


// MARK: - Class FeedLoaderCacheDecorator
final class FeedLoaderCacheDecorator: FeedLoaderProtocol {
    private let decoratee: FeedLoaderProtocol
    private let cache: FeedCacheProtocol
    
    
    init(decoratee: FeedLoaderProtocol, cache: FeedCacheProtocol) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    
    func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        decoratee.load { [weak self] result in
            guard let self else { return }
            
            self.cache.save((try? result.get()) ?? []) { _ in }
            completion(result)
        }
    }
}


// MARK: - Class FeedLoaderCacheDecoratorTests
final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCaseProtocol {
    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    
    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    
    func test_load_cachesLoadedFeedOnLoaderSuccess() {
        let cache = CacheSpy()
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [.save(feed)], "Expected to cache loaded feed on success")
    }
    
    
    // MARK: - Helpers
    private func makeSUT(loaderResult: FeedLoaderProtocol.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedLoaderProtocol {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    
    private class CacheSpy: FeedCacheProtocol {
        private(set) var messages = [Message]()
        
        
        enum Message: Equatable {
            case save([FeedImage])
        }
        
        
        func save(_ feed: [FeedImage], completion: @escaping (FeedCacheProtocol.Result) -> Void) {
            messages.append(.save(feed))
            completion(.success(()))
        }
    }
}
