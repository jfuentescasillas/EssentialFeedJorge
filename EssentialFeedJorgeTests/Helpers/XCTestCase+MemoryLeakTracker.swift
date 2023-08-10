//
//  XCTestCase+MemoryLeakTracker.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 10/08/23.
//


import XCTest


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
