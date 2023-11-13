//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 13/11/23.
//


import XCTest
import EssentialFeedJorge


class RemoteFeedImageDataLoader {
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    
    func loadImageData(from url: URL, completion: @escaping (Any) -> Void) {
        client.get(from: url) { _ in }
    }
}


class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    // MARK: - Private Methods
    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
       
        return (sut, client)
    }
    
    
    private class HTTPClientSpy: HTTPClientProtocol {
        var requestedURLs = [URL]()
        
        
        func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) {
            requestedURLs.append(url)
        }
    }
}
