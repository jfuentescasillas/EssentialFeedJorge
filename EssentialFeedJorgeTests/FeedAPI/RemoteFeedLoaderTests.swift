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
               toCompleteWithResult: failure(.connectivity),
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
                   toCompleteWithResult: failure(.invalidData),
                   whenAction: {
                let jsonData = makeItemsJSON(with: [])
                client.complete(withStatusCode: code,
                                data: jsonData,
                                at: idx)
            })
        }
    }
    
    
    func test_load_deliverErrorOn200HTTPResponseWithInvalidJSON() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        // Call the ACT and ASSERT: When we invoke sut.load() it's asynchronous so we pass a completion block
        expect(arrangeSUT: sut,
               toCompleteWithResult: failure(.invalidData),
               whenAction: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        // Call the ACT and ASSERT
        expect(arrangeSUT: sut,
               toCompleteWithResult: .success([]),
               whenAction: {
            let emptyListJSON = makeItemsJSON(with: [])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "https://a-url.com")!)
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "https://another-url.com")!)
        let itemsModel = [item1.model, item2.model]
        
        expect(arrangeSUT: sut,
               toCompleteWithResult: .success(itemsModel),
               whenAction: {
            let jsonData = makeItemsJSON(with: [item1.json, item2.json])
            client.complete(withStatusCode: 200,
                            data: jsonData)
        })
    }
    
    
    func test_load_doesNotDeliversResultAfterSUTInstanceHasBeenDeallocated() {
        // ARRANGE: Given a SUT (System Under Test) and a client
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        var capturedResults = [RemoteFeedLoader.Result]()

        // ACT: When we invoke sut.load()
        sut?.load { capturedResults.append($0) }
        
        sut = nil        
        client.complete(withStatusCode: 200, data: makeItemsJSON(with: []))
        
        // ASSERT: Then assert that the results are empty (related to the line of code
        // 'guard self != nil else { return }' in RemoteFeedLoader.load(...))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    
    // MARK: - Helper Methods
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) ->
    (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        // Control memory leaks after each test runs
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)                            
        
        return (sut, client)
    }
    
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    
    private func makeItem(id: UUID, description: String? = nil,
                          location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let item = FeedItem(
            id: id,
            description: description,
            location: location,
            imageURL: imageURL
        )
        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.imageURL.absoluteString
        ].compactMapValues { $0 }  // Eliminate nil values
        
        return (item, json)
    }
    
    
    private func makeItemsJSON(with items: [[String: Any]]) -> Data {
        let itemsJSON = ["items": items]
        let jsonData = try! JSONSerialization.data(withJSONObject: itemsJSON)
        
        return jsonData
    }
    
    
    private func expect(arrangeSUT sut: RemoteFeedLoader, toCompleteWithResult expectedResult: RemoteFeedLoader.Result, whenAction action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        // ACT: When we invoke sut.load() it's asynchronous so we pass a completion block
        let exp = expectation(description: "Waiting for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                // ASSERT: Then assert that the type of error is .connectivity
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteFeedLoader.Error),
                      .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result: \(expectedResult); but got \(receivedResult)", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    
    // MARK: - Helper Class
    class HTTPClientSpy: HTTPClient {
        // MARK: - Properties
        var requestedURL: URL?
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        
        // MARK: - Methods
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
            requestedURL = url
        }
        
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        
        func complete(withStatusCode: Int, data: Data, at index: Int = 0) {
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
