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
    private let currentDate: () -> Date
    
    
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    
    func save(items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            
            completion(error)
            
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate())
            }
        }
    }
}


// MARK: - FeedStore Class
class FeedStore {
    enum ReceivedMsg: Equatable {
        case deleteCachedFile
        case insert([FeedItem], Date)
    }
    
    
    typealias DeletionCompletion = (Error?) -> Void
    
    private var deletionCompletions = [DeletionCompletion]()
    private(set) var receivedMsgs = [ReceivedMsg]()
    
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMsgs.append(.deleteCachedFile)
    }
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    
    func insert(_ items: [FeedItem], timestamp: Date) {
        receivedMsgs.append(.insert(items, timestamp))
    }
}


// MARK: - CacheFeedUseCaseTests
final class CacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMsgs, [])
    }
    
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items: items) { _ in }
        
        // XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
        XCTAssertEqual(store.receivedMsgs, [.deleteCachedFile])
    }
    
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items: items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMsgs, [.deleteCachedFile])
    }
    
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT(currentDate: { timestamp })
        
        sut.save(items: items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMsgs, [.deleteCachedFile, .insert(items, timestamp)])
    }
    
    
    func test_save_failsOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        var receivedError: Error?
        
        sut.save(items: items) { error in
            receivedError = error
            exp.fulfill()
        }
        
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(receivedError as NSError?, deletionError as NSError)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
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
