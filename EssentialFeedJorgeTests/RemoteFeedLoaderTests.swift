//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 02/08/23.
//


import XCTest


// MARK: - RemoteFeedLoader
class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    func load() {
        client.get(from: url)
    }
}


// MARK: - HTTPClient
protocol HTTPClient {
    func get(from url: URL?)
}


// MARK: - Tests Class
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (_, client) = makeSUT()
        
        /* Old code
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        let _ = RemoteFeedLoader(url: url, client: client)  // SUT not used in this case */
        
        // ACT: When we invoke sut.load()
        // In this case is not invoked
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURL() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        // let sut = RemoteFeedLoader(url: url, client: client)
        
        // ACT: When we invoke sut.load()
        sut.load()
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURLAndURLsAreEqual() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        // let sut = RemoteFeedLoader(url: url, client: client)
        
        // ACT: When we invoke sut.load()
        sut.load()
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertEqual(client.requestedURL, url)
    }
    
    
    // MARK: - Private Helpers
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        
       func get(from url: URL?) {
            requestedURL = url
        }
    }

    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) ->
    (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
}
