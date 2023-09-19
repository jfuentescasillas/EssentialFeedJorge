//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 15/09/23.
//


import Foundation
import EssentialFeedJorge
import EssentialFeedJorgeiOS


// MARK: - Extension. FeedUIIntegrationTests
extension FeedUIIntegrationTests {
    // MARK: - LoaderSpy class
    class LoaderSpy: FeedLoaderProtocol, FeedImageDataLoaderProtocol {
        // MARK: Feed Loader
        private var feedRequests = [(FeedLoaderProtocol.Result) -> Void]()
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        
        func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
            feedRequests.append(completion)
        }
        
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            
            feedRequests[index](.failure(error))
        }
        
        
        // MARK: FeedImageDataLoader
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            
            func cancel() {
                cancelCallback()
            }
        }
        
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoaderProtocol.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        private(set) var cancelledImageURLs = [URL]()
        
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoaderProtocol.Result) -> Void) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}
