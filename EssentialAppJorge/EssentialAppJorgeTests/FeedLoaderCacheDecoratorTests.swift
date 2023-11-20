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
final class FeedLoaderCacheDecoratorTests: XCTestCase {
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
    private func expect(_ sut: FeedLoaderProtocol, toCompleteWith expectedResult: FeedLoaderProtocol.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedRsult in
            switch(receivedRsult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedRsult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
    }
}
