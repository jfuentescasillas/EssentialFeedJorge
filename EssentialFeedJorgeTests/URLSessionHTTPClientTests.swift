//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/08/23.
//


import XCTest
import EssentialFeedJorge


class URLSessionHTTPClient {
    private let session: URLSession!
    
    
    init(session: URLSession!) {
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
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in}
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy()
        session.stub(url: url, error: error)
        
        let exp = expectation(description: "Waiting for completion")
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            
            default:
                XCTFail("Expected failure with error \(error) but got \(result) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    // MARK: - Helpers
    private class URLSessionSpy: URLSession {
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        
        private var stubs = [URL: Stub]()
        
        
        override init() {
            super.init()
            // Your initialization code for URLSessionSpy here
        }
        
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            
            return stub.task
        }
        
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
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
