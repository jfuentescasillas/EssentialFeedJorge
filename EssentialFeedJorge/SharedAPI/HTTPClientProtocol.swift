//
//  HTTPClient.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 08/08/23.
//


import Foundation


// MARK: - Protocol HTTPClientTask
public protocol HTTPClientTask {
    func cancel()
}


// MARK: - Protocol HTTPClient
public protocol HTTPClientProtocol {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
