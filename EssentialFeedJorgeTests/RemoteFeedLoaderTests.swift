//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 02/08/23.
//


import XCTest


// MARK: - RemoteFeedLoader
class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    
    func load() {
        client.get(from: URL(string: "https://a-url.com"))
    }
}


// MARK: - HTTPClient and HTTPClientSpy
protocol HTTPClient {
    func get(from url: URL?)
}


class HTTPClientSpy: HTTPClient {
    func get(from url: URL?) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}


// MARK: - Tests Class
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let _ = RemoteFeedLoader(client: client)  // SUT not used in this case
        
        XCTAssertNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURL() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        // ACT: When we invoke sut.load()
        sut.load()
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
}
