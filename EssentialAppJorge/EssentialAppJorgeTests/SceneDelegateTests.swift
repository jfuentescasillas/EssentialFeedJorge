//
//  SceneDelegateTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 24/11/23.
//


import XCTest
import EssentialFeedJorgeiOS
@testable import EssentialAppJorge


class SceneDelegateTests: XCTestCase {
    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        sut.configWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead.")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead.")
    }
}
