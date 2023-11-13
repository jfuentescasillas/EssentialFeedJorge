//
//  SharedTestsHelpers.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 21/08/23.
//


import Foundation


func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}


func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
