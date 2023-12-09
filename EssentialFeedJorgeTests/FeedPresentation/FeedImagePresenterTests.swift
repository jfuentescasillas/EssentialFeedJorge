//
//  FeedImagePresenterTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 11/10/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - FeedImagePresenterTests
class FeedImagePresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let image = uniqueImage()
        let viewModel = FeedImagePresenter.map(image)

        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
}
