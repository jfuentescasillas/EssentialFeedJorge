//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 20/11/23.
//


import XCTest
import EssentialFeedJorge
import EssentialAppJorge


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
    
    
    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
        
        sut.load { _ in }

        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache feed on load error")
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