//
//  URLSessionHTTPClient.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 10/08/23.
//


import Foundation

public final class URLSessionHTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    
    public func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}
