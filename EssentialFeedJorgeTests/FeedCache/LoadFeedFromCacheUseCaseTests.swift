//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 18/08/23.
//


import XCTest
import EssentialFeedJorge


final class LoadFeedFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMsgs, [])
    }
    
    
    func test_load_requestCacheRetrieval() {
        let (sut, store) = makeSUT()
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMsgs, [.retrieve])
    }
    
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedError: Error?
        
        sut.load() { result in
            switch result {
            case let .failure(error):
                receivedError = error
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)) instead.")
            }
            
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as? NSError, retrievalError as NSError)
    }
    
    
    // MARK: - Helper Methods
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    
    private func anyNSError() -> Error {
        return NSError(domain: "any error", code: 0)
    }
}
