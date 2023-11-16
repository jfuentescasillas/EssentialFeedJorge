//
//  FeedLoaderProtocolWithFallbackCompositeTests.swift
//  EssentialAppJorgeTests
//
//  Created by jfuentescasillas on 16/11/23.
//


import XCTest
import EssentialFeedJorge


// MARK: - FeedLoaderWithFallbackComposite
class FeedLoaderWithFallbackComposite: FeedLoaderProtocol {
    private let primary: FeedLoaderProtocol

    
    init(primary: FeedLoaderProtocol, fallback: FeedLoaderProtocol) {
        self.primary = primary
    }

    
    func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
        primary.load(completion: completion)
    }
}


// MARK: - FeedLoaderWithFallbackCompositeTests
class FeedLoaderProtocolWithFallbackCompositeTests: XCTestCase {
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        let primaryLoader = LoaderStub(result: .success(primaryFeed))
        let fallbackLoader = LoaderStub(result: .success(fallbackFeed))
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(receivedFeed, primaryFeed)

            case .failure:
                XCTFail("Expected successful load feed result, got \(result) instead")
            }

            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }

    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
    }

    
    private class LoaderStub: FeedLoaderProtocol {
        private let result: FeedLoaderProtocol.Result

        
        init(result: FeedLoaderProtocol.Result) {
            self.result = result
        }

        
        func load(completion: @escaping (FeedLoaderProtocol.Result) -> Void) {
            completion(result)
        }
    }
}
