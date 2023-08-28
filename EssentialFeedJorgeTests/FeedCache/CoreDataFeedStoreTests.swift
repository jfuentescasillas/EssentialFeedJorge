//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 28/08/23.
//


import XCTest
import EssentialFeedJorge


final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecsProtocol {
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
        
    }
    
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        
    }
    
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        
    }
    
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        
    }
    
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        
    }
    
    
    func test_storeSideEffects_runSerially() {
        
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStoreProtocol {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}