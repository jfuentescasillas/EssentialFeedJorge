//
//  FeedPresenterTests.swift
//  EssentialFeedJorgeTests
//
//  Created by jfuentescasillas on 09/10/23.
//


import XCTest


// MARK: - View Models
struct FeedLoadingViewModel {
    let isLoading: Bool
}


struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
}


// MARK: - Protocols
protocol FeedLoadingViewProtocol {
    func display(_ viewModel: FeedLoadingViewModel)
}


protocol FeedErrorViewProtocol {
    func display(_ viewModel: FeedErrorViewModel)
}


// MARK: - FeedPresenter
final class FeedPresenter {
    private let loadingView: FeedLoadingViewProtocol
    private let errorView: FeedErrorViewProtocol
    
    init(loadingView: FeedLoadingViewProtocol, errorView: FeedErrorViewProtocol) {
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
}


class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
       
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages,
                       [.display(errorMessage: .none),
                        .display(isLoading: true)
                       ])
    }
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(loadingView: view, errorView: view)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    
    private class ViewSpy: FeedLoadingViewProtocol, FeedErrorViewProtocol {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
        }
        
        
        private(set) var messages = Set<Message>()
        
        
        // Method of FeedLoadingViewProtocol
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        
        // Method of FeedErrorViewProtocol
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
    }
}
