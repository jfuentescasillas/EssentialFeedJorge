//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/08/23.
//


import XCTest
import EssentialFeedJorge


class URLSessionHTTPClient {
    private let session: URLSession
    
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}


class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequest()
    }
    
    
    override class func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequest()
}
    
    func test_getFromURL_performsGETRequestWithURL() {
        // Used "expectation" when the block is asynchronously invoked
        let exp = expectation(description: "Waiting for request")
        let url = URL(string: "https://any-url.com")!
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        URLSessionHTTPClient().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://any-url.com")!
        let requestedError = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: requestedError)
        
        // Used "expectation" when the block is asynchronously invoked
        let exp = expectation(description: "Waiting for completion")

        makeSUT().get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, requestedError.domain)
                XCTAssertEqual(receivedError.code, requestedError.code)
                XCTAssertNotNil(receivedError)
                
            default:
                XCTFail("Expected failure with error \(requestedError) but got \(result) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    // MARK: - Helpers
    private func makeSUT() -> URLSessionHTTPClient {
        return URLSessionHTTPClient()
    }
    

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
            requestObserver?(request)
            
            return true
        }
        
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        
        override func startLoading() {
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
