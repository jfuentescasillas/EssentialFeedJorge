//
//  HTTPClientSpy.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 14/11/23.
//


import Foundation
import EssentialFeedJorge


class HTTPClientSpy: HTTPClientProtocol {
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        
        
        func cancel() { callback() }
    }
    
    
    private var messages = [(url: URL, completion: (HTTPClientProtocol.Result) -> Void)]()
    private(set) var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    
    func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        
        let task = Task { [weak self] in
            guard let self else { return }
            
            self.cancelledURLs.append(url)
        }
        
        return task
    }
    
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        
        messages[index].completion(.success((data, response)))
    }
}
