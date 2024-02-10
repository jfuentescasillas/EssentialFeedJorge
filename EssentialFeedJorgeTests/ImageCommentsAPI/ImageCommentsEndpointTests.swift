//
//  ImageCommentsEndpointTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 10/02/24.
//


import XCTest
import EssentialFeedJorge


class ImageCommentsEndpointTests: XCTestCase {
    func test_imageComments_endpointURL() {
        let imageID = UUID(uuidString: "2239CBA2-CB35-4392-ADC0-24A37D38E010")!
        let baseURL = URL(string: "http://base-url.com")!

        let received = ImageCommentsEndpoint.get(imageID).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/image/2239CBA2-CB35-4392-ADC0-24A37D38E010/comments")!

        XCTAssertEqual(received, expected)
    }
}
