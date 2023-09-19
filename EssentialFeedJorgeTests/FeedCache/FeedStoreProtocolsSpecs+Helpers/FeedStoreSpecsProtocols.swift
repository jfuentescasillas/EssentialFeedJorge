//
//  FeedStoreSpecsProtocols.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 25/08/23.
//


import Foundation


protocol FeedStoreSpecsProtocol {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()
    
    func test_insert_deliversNoErrorOnEmptyCache()
    func test_insert_deliversNoErrorOnNonEmptyCache()
    func test_insert_overridesPreviouslyInsertedCacheValues()
    
    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_deliversNoErrorOnNonEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()
    
    func test_storeSideEffects_runSerially()
}


protocol FailableRetrieveFeedStoreSpecsProtocol: FeedStoreSpecsProtocol {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}


protocol FailableInsertFeedStoreSpecsProtocol: FeedStoreSpecsProtocol {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}


protocol FailableDeleteFeedStoreSpecsProtocol: FeedStoreSpecsProtocol {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}


typealias FailableFeedStoreSpecsProtocols = FailableRetrieveFeedStoreSpecsProtocol & FailableInsertFeedStoreSpecsProtocol & FailableDeleteFeedStoreSpecsProtocol
