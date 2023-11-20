//
//  FeedLoaderStub.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 20/11/23.
//


import EssentialFeedJorge


class FeedLoaderStub: FeedLoaderProtocol {
    private let result: FeedLoaderProtocol.Result
    
    
    init(result: FeedLoaderProtocol.Result) {
        self.result = result
    }
    
    
    func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        completion(result)
    }
}
