//
//  FeedLoaderProtocolWithFallbackCompositeTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 16/11/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - FeedLoaderWithFallbackComposite
class FeedLoaderWithFallbackComposite: FeedLoaderProtocol {
    private let primary: FeedLoaderProtocol
    private let fallback: FeedLoaderProtocol
    
    
    init(primary: FeedLoaderProtocol, fallback: FeedLoaderProtocol) {
        self.primary = primary
        self.fallback = fallback
    }
    
    
    func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        primary.load { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self.fallback.load(completion: completion)
            }
        }
    }
}


// MARK: - FeedLoaderWithFallbackCompositeTests
class FeedLoaderProtocolWithFallbackCompositeTests: XCTestCase {
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))
        
        expect(sut, toCompleteWith: .success(primaryFeed))
    }
    
    
    func test_load_deliversFallbackFeedOnPrimaryLoaderFailure() {
        let fallbackFeed = uniqueFeed()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))
        
        expect(sut, toCompleteWith: .success(fallbackFeed))
    }
    
    
    func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    
    // MARK: - Helpers
    private func makeSUT(primaryResult: FeedLoaderProtocol.Result, fallbackResult: FeedLoaderProtocol.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoaderProtocol {
        let primaryLoader = LoaderStub(result: primaryResult)
        let fallbackLoader = LoaderStub(result: fallbackResult)
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    
    private func expect(_ sut: FeedLoaderProtocol, toCompleteWith expectedResult: FeedLoaderProtocol.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
    }
    
    
    private class LoaderStub: FeedLoaderProtocol {
        private let result: FeedLoaderProtocol.Result
        
        
        init(result: FeedLoaderProtocol.Result) {
            self.result = result
        }
        
        
        func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
            completion(result)
        }
    }
}
