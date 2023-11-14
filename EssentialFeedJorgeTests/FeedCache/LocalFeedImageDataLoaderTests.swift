//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 14/11/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - FeedImageDataStoreProtocol
protocol FeedImageDataStoreProtocol {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}


// MARK: - Class LocalFeedImageDataLoader
final class LocalFeedImageDataLoader: FeedImageDataLoaderProtocol {
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    
    public enum Error: Swift.Error {
        case failed
    }


    private let store: FeedImageDataStoreProtocol
    
    
    init(store: FeedImageDataStoreProtocol) {
        self.store = store
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        store.retrieve(dataForURL: url) { result in
            completion(.failure(Error.failed))
        }
        
        return Task()
    }
}


// MARK: - Class LocalFeedImageDataLoaderTests
class LocalFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }

    
    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed(), when: {
            let retrievalError = anyNSError()
            store.complete(with: retrievalError)
        })
    }
    
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    
    private func failed() -> FeedImageDataLoaderProtocol.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }
    
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoaderProtocol.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case (.failure(let receivedError as LocalFeedImageDataLoader.Error),
                  .failure(let expectedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    private class StoreSpy: FeedImageDataStoreProtocol {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        
        private var completions = [(FeedImageDataStoreProtocol.Result) -> Void]()
        private(set) var receivedMessages = [Message]()
        
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.Result) -> Void) {
            receivedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }
}
