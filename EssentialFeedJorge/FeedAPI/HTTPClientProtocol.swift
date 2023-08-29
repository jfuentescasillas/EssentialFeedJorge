//
//  HTTPClient.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 08/08/23.
//


import Foundation


// MARK: - Global Enums
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


// MARK: - Protocol HTTPClient
public protocol HTTPClientProtocol {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}


