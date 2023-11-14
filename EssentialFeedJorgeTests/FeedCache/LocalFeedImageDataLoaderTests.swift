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
    func retrieve(dataForURL url: URL)
}


// MARK: - Class LocalFeedImageDataLoader
final class LocalFeedImageDataLoader: FeedImageDataLoaderProtocol {
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    
    private let store: FeedImageDataStoreProtocol
    
    
    init(store: FeedImageDataStoreProtocol) {
        self.store = store
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        store.retrieve(dataForURL: url)
        
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

    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    
    private class StoreSpy: FeedImageDataStoreProtocol {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        
        private(set) var receivedMessages = [Message]()
        
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
}
