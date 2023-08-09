//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/08/23.
//


import XCTest


class URLSessionHTTPClient {
    private let session: URLSession!
    
    init(session: URLSession!) {
        self.session = session
    }
    
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}


class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
}
    
    
    // MARK: - Helpers
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()

        
        override init() {
            super.init()
            // Your initialization code for URLSessionSpy here
        }
        
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return FakeURLSessionDataTask()
        }
    }
    
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override init() {
            // Initialize any properties or perform any setup needed for FakeURLSessionDataTask
        }
    }
}
