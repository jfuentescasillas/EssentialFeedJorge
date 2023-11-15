//
//  EssentialFeedJorgeCacheIntegrationTests.swift
//  EssentialFeedJorgeCacheIntegrationTests
//
//  Created by jfuentescasillas on 29/08/23.
//


import XCTest
import EssentialFeedJorge


final class EssentialFeedJorgeCacheIntegrationTests: XCTestCase {
    // Setup is invoked BEFORE every test method execution
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    
    // Setup is invoked AFTER every test method execution
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    
    // MARK: - Testing Methods
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { result in
            switch result {
            case let .success (imageFeed):
                XCTAssertEqual(imageFeed, [], "Expected empty feed")
                
            case let .failure (error):
                XCTFail ("Expected successful feed result, got \(error) instead")
            }
            
            exp.fulfill ()
        }
        
        wait (for: [exp], timeout: 1.0)
    }
    
    
    // MARK: - Helper Methods
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    
    private func save(_ feed: [FeedImage], with loader: LocalFeedLoader, file: StaticString = #file, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.save(feed: feed) { result in
            if case let Result.failure(error) = result {
                XCTAssertNil(error, "Expected to save feed successfully", file: file, line: line)
            }
            saveExp.fulfill()
        }
        
        wait(for: [saveExp], timeout: 1)
    }
    
    
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wati for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent ("\(type (of: self)).store")
    }
    
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
