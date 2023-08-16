//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 16/08/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - LocalFeedLoader Class
class LocalFeedLoader {
    private let store: FeedStore
    
    
    init(store: FeedStore) {
        self.store = store
    }
    
    
    func save(items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}


// MARK: - FeedStore Class
class FeedStore {
    var deleteCachedFeedCallCount: Int = 0
    var insertCallCount: Int = 0
    
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        
    }
}


// MARK: - CacheFeedUseCaseTests
final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items: items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items: items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    
    private func uniqueItem() -> FeedItem {
        let item = FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
        
        return item
    }
    
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    
    private func anyNSError() -> Error {
        return NSError(domain: "any error", code: 0)
    }
}
