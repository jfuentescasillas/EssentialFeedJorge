//
//  FeedAcceptanceTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 24/11/23.
//


import XCTest
import EssentialFeedJorge
import EssentialFeedJorgeiOS
@testable import EssentialAppJorge


class FeedAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData())
    }
    
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        
    }
    
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        
    }
    
    
    // MARK: - Helpers
    private func launch(httpClient: HTTPClientStub = .offline, store: InMemoryFeedStore = .empty) -> FeedViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        
        return nav?.topViewController as! FeedViewController
    }
    
    
    private class HTTPClientStub: HTTPClientProtocol {
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
        
        
        static var offline: HTTPClientStub {
            HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
        }
        
        
        static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            HTTPClientStub { url in .success(stub(url)) }
        }
    }
    
    
    private class InMemoryFeedStore: FeedStoreProtocol, FeedImageDataStoreProtocol {
        private var feedCache: CachedFeed?
        private var feedImageDataCache: [URL: Data] = [:]
        
        
        func deleteCachedFeed(completion: @escaping FeedStoreProtocol.DeletionCompletion) {
            feedCache = nil
            completion(.success(()))
        }
        
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStoreProtocol.InsertionCompletion) {
            feedCache = CachedFeed(feed: feed, timestamp: timestamp)
            completion(.success(()))
        }
        
        
        func retrieve(completion: @escaping FeedStoreProtocol.RetrievalCompletion) {
            completion(.success(feedCache))
        }
        
        
        func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStoreProtocol.InsertionResult) -> Void) {
            feedImageDataCache[url] = data
            completion(.success(()))
        }
        
        
        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStoreProtocol.RetrievalResult) -> Void) {
            completion(.success(feedImageDataCache[url]))
        }
        
        
        static var empty: InMemoryFeedStore {
            InMemoryFeedStore()
        }
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        return (makeData(for: url), response)
    }
    
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()
            
        default:
            return makeFeedData()
        }
    }
    
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "http://image.com"],
            ["id": UUID().uuidString, "image": "http://image.com"]
        ]])
    }
}
