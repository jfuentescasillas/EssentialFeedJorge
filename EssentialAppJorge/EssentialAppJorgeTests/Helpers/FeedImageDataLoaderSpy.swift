//
//  FeedImageDataLoaderSpy.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 21/11/23.
//


import Foundation
import EssentialFeedJorge


class FeedImageDataLoaderSpy: FeedImageDataLoaderProtocol {
    private var messages = [(url: URL, completion: (FeedImageDataLoaderProtocol.Result) -> Void)]()
    private(set) var cancelledURLS = [URL]()
    var loadedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    
    private struct Task: FeedImageDataLoaderTask {
        let callback: () -> Void
        
        
        func cancel() { callback() }
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
        messages.append((url, completion))
        
        let task = Task { [weak self] in
            guard let self else { return }
            
            self.cancelledURLS.append(url)
        }
        
        return task
    }
    
    
    func complete(with data: Data, at index: Int = 0) {
        messages[index].completion(.success(data))
    }
    
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
}
