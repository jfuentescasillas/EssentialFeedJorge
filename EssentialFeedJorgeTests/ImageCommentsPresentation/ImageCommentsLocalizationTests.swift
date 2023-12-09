//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/12/23.
//


import XCTest
import EssentialFeedJorge


class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
