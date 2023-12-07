//
//  SharedLocalizationTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 07/12/23.
//


import XCTest
import EssentialFeedJorge


final class SharedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
    
    // MARK: - Helpers
    private class DummyView: ResourceViewProtocol {
        func display(_ viewModel: Any) {}
    }
}
