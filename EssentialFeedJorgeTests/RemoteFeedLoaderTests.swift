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
        
        // ACT: When we invoke sut.load()
        sut.load()
        sut.load()

        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    
    // MARK: - Private Helpers
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var requestedURLs = [URL]()
        
        
        func get(from url: URL) {
            requestedURL = url
            requestedURLs.append(url)
        }
    }
    
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) ->
    (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
}
