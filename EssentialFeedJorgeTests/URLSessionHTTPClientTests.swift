//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/08/23.
//


import XCTest
import EssentialFeedJorge


class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequest()
    }
    
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        // Used "expectation" when the block is asynchronously invoked
        let exp = expectation(description: "Waiting for request")
        let url = anyURL()
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        URLSessionHTTPClient().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_getFromURL_failsOnRequestError() {
        let requestedError = NSError(domain: "any error", code: 1)
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestedError) as? NSError
        
        XCTAssertEqual(receivedError?.domain, requestedError.domain)
        XCTAssertEqual(receivedError?.code, requestedError.code)
        XCTAssertNotNil(receivedError)
        
    }
    
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        // ARRANGE: Given
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        // ACT: When
        let receivedValues = resultValuesFor(data: data, response: response, error: nil)
        
        // ASSERT: Then
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        // ARRANGE: Given
        let response = anyHTTPURLResponse()
        
        // ACT: When
        let receivedValues = resultValuesFor(data: nil, response: response, error: nil)
        let emptyData = Data()
        
        // ASSERT: Then
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    
    // MARK: - Helpers
    // MARK: Private Methods
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClientProtocol {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
            
        default:
            XCTFail("Expected failure with result \(result).", file: file, line: line)
            
            return nil
        }
    }
    
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch result {
        case let .success(data, response):
            return (data, response)
            
        default:
            XCTFail("Expected success with result \(result).", file: file, line: line)
            
            return nil
        }
    }
    
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClientResult {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        
        // Use "expectation" when the block is asynchronously invoked
        let exp = expectation(description: "Waiting for completion")
        var receivedResult: HTTPClientResult!
        
        sut.get(from: anyURL()) { result in
            receivedResult = result
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        return receivedResult
    }
    
    
    // MARK: - Private Class
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
            
        }
        
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequest() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        
        static func stopInterceptingRequest() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            requestObserver = nil
            stub = nil  // Remove stubs
        }
        
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        
        override func startLoading() {
            /* This if let requestObserver prevents "data races". This is: every request is finished
               before the test method using the URLProtocolStub returns, so we won't have any
               requests running in background threads concurrently with other test methods.       */
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                
                return requestObserver(request)
            }

            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        
        override func stopLoading() {}  // If not implemented, there's a crash
    }
}
