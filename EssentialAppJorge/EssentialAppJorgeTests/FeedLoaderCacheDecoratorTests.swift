//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 20/11/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - Class FeedLoaderCacheDecorator
final class FeedLoaderCacheDecorator: FeedLoaderProtocol {
    private let decoratee: FeedLoaderProtocol
    
    
    init(decoratee: FeedLoaderProtocol) {
        self.decoratee = decoratee
    }
    
    
    func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}


// MARK: - Class FeedLoaderCacheDecoratorTests
final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCaseProtocol {
    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let loader = FeedLoaderStub(result: .success(feed))
        let sut = FeedLoaderCacheDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    
    func test_load_deliversErrorOnLoaderFailure() {
        let loader = FeedLoaderStub(result: .failure(anyNSError()))
        let sut = FeedLoaderCacheDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    
    // MARK: - Helpers
    private func makeSUT(loaderResult: FeedLoaderProtocol.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoaderProtocol {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
