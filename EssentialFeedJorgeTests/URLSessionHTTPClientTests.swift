//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/08/23.
//


import XCTest
import EssentialFeedJorge


protocol HTTPSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTaskProtocol
}


protocol HTTPSessionTaskProtocol {
    func resume()
}


class URLSessionHTTPClient {
    private let session: HTTPSessionProtocol
    
    
    init(session: HTTPSessionProtocol) {
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
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in}
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        let session = HTTPSessionSpy()
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
    private class HTTPSessionSpy: HTTPSessionProtocol {
        private struct Stub {
            let task: HTTPSessionTaskProtocol
            let error: Error?
        }
        
        
        private var stubs = [URL: Stub]()
        
        
        func stub(url: URL, task: HTTPSessionTaskProtocol = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTaskProtocol {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            
            return stub.task
        }
    }
    
    
    private class FakeURLSessionDataTask: HTTPSessionTaskProtocol {
        func resume() {}
    }
    
    
    private class URLSessionDataTaskSpy: HTTPSessionTaskProtocol {
        var resumeCallCount: Int = 0
        
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
