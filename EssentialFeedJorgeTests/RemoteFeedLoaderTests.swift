//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 02/08/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - Tests Class
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (_, client) = makeSUT()
        
        // ACT: When we invoke sut.load()
        // In this case is not invoked
        
        // ASSERT: Then assert that a URL request was initiated in the client.
        // Here, we assert that it wasn't done a URL Request since that only
        // happens when .load() is invoked
        XCTAssertNil(client.requestedURL)
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    
    func test_load_requestsDataFromURL() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        
        // ACT: When we invoke sut.load(), a URL Request is made.
        sut.load()
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURLAndURLsAreEqual() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        
        // ACT: When we invoke sut.load()
        sut.load()
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertEqual(client.requestedURL, url)
    }
    
    
    func test_loadTwice_requestDataFromURLAndURLsAreEqualTwice() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        
        // ACT: When we invoke sut.load() twice
        sut.load()
        sut.load()

        // ASSERT: Then assert that the same amount of URL calls (2 calls) are the same. With this we make sure that the RemoteFeedLoader.load(...) is called once per each call
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    
    func test_load_deliversErrorOnClientError() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        // ACT: When we invoke sut.load() it's asynchronous so we pass a completion block
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        // ASSERT: Then assert that the type of error is .connectivity
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    
    // MARK: - Private Helpers
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()
        
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            requestedURL = url
            requestedURLs.append(url)
            completions.append(completion)
        }
        
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](error)
        }
    }
    
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) ->
    (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
}
