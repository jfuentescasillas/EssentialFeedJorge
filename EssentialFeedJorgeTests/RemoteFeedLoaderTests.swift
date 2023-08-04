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
    // MARK: - Methods to Request Data From URL
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
        sut.load { _ in }
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
    }
    
    
    func test_load_requestDataFromURLAndURLsAreEqual() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        
        // ACT: When we invoke sut.load()
        sut.load { _ in }
        
        // ASSERT: Then assert that a URL request was initiated in the client
        XCTAssertEqual(client.requestedURL, url)
    }
    
    
    func test_loadTwice_requestDataFromURLAndURLsAreEqualTwice() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url) // HTTPClientSpy()
        
        // ACT: When we invoke sut.load() twice
        sut.load { _ in }
        sut.load { _ in }

        // ASSERT: Then assert that the same amount of URL calls (2 calls) are the same. With this we make sure that the RemoteFeedLoader.load(...) is called once per each call
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    
    // MARK: - Methods to Deliver Errors
    func test_load_deliversErrorOnClientError() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        // Call the ACT and ASSERT with "expect()" method
        expect(arrangeSUT: sut,
               toCompleteWithError: .connectivity,
               whenAction: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    
    func test_load_DeliversErrorOnNon200HTTPResponse() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        // Call the ACT and ASSERT with "expect()" method
        let codeSamples: [Int] = [199, 201, 300, 400, 500]
        codeSamples.enumerated().forEach { idx, code in
            expect(arrangeSUT: sut,
                   toCompleteWithError: .invalidData,
                   whenAction: {
                client.complete(withStatusCode: code,
                                at: idx)
            })
        }
    }
    
    
    func test_load_deliverErrorOn200HTTPResponseWithInvalidJSON() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        // Call the ACT and ASSERT: When we invoke sut.load() it's asynchronous so we pass a completion block
        expect(arrangeSUT: sut,
               toCompleteWithError: .invalidData,
               whenAction: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    
    // MARK: - Helper Methods
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) ->
    (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    
    private func expect(arrangeSUT sut: RemoteFeedLoader, toCompleteWithError error: RemoteFeedLoader.Error, whenAction action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        // ACT: When we invoke sut.load() it's asynchronous so we pass a completion block
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        action()
        
        // ASSERT: Then assert that the type of error is .connectivity
        XCTAssertEqual(capturedErrors, [error], file: file, line: line)
    }
    
    
    // MARK: - Helper Class
    class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
            requestedURL = url
        }
        
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        
        func complete(withStatusCode: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: withStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data, response))
        }
    }
}
