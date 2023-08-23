//
//  CodableFeedStoreTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 23/08/23.
//


import XCTest
import EssentialFeedJorge


class CodableFeedStore {
    func retrieve(completion: @escaping FeedStoreProtocol.RetrievalCompletion) {
        completion(.empty)
    }
}


final class CodableFeedStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
                
            default:
                XCTFail("Expected empty, got: \"\(result)\" instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { resultOne in
            sut.retrieve { resultTwo in
                switch (resultOne, resultTwo) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty reslut, got: \"\(resultOne)\" and \"\(resultTwo)\" instead.")
                }
                
                exp.fulfill()
            }
    }
        
        wait(for: [exp], timeout: 1)
    }
}
