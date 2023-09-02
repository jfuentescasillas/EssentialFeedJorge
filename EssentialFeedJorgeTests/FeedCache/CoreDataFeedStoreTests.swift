//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 28/08/23.
//


import XCTest
import EssentialFeedJorge


final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecsProtocol /* FailableFeedStoreSpecsProtocols */ {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        
        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        assertThatSideEffectsRunSerially(on: sut)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStoreProtocol {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        
        return sut
    }
}


// MARK: - Extension. FailableFeedStoreSpecsProtocols
/* extension CoreDataFeedStoreTests {
    func test_retrieve_deliversFailureOnRetrievalError() {
        /*let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL) */
        
        let sut = makeSUT()
        
        // try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        /* let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL) */
        
        let sut = makeSUT()
        
        // try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
    }
    
    
    func test_insert_deliversErrorOnInsertionError() {
        /*let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)*/
        
        let sut = makeSUT()
        
        assertThatInsertDeliversErrorOnInsertionError(on: sut)
    }
    
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        /*let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)*/
        
        let sut = makeSUT()
        
        assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
    }
    
    
    func test_delete_deliversErrorOnDeletionError() {
        /* let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL) */
        
        let sut = makeSUT()
        
        assertThatDeleteDeliversErrorOnDeletionError(on: sut)
    }
    
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        /* let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL) */
        
        let sut = makeSUT()
        
        assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
    }
}
*/
