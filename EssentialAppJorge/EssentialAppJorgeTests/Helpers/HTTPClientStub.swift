//
//  HTTPClientStub.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 24/11/23.
//


import Foundation
import EssentialFeedJorge


class HTTPClientStub: HTTPClientProtocol {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    
    private let stub: (URL) -> HTTPClientProtocol.Result
    
    
    init(stub: @escaping (URL) -> HTTPClientProtocol.Result) {
        self.stub = stub
    }
    
    
    func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}
    
 
extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
