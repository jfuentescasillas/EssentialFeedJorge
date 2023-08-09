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
        session.dataTask(with: url) { _, _, _ in }.resume()
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
    
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    
    // MARK: - Helpers
    private class URLSessionSpy: URLSession {
        var receivedURLs = [URL]()
        private var stubs = [URL: URLSessionDataTask]()
        
        
        override init() {
            super.init()
            // Your initialization code for URLSessionSpy here
        }
        
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            
            return stubs[url] ?? FakeURLSessionDataTask()
        }
        
        
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
    }
    
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override init() {
            // Initialize any properties or perform any setup needed for FakeURLSessionDataTask
        }
        
        
        override func resume() {}
    }
    
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount: Int = 0
        
        
        override init() {
            // Initialize any properties or perform any setup needed for FakeURLSessionDataTask
        }
        
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
