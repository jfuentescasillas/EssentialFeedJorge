//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeedJorgeiOSTests
//
//  Created by jfuentescasillas on 17/12/23.
//


import XCTest
import EssentialFeedJorgeiOS
@testable import EssentialFeedJorge


final class ImageCommentsSnapshotTests: XCTestCase {
    func test_listWithComments() {
        let sut = makeSUT()
        sut.display(comments())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_dark")
    }
    
    
    // MARK: - Helpers
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        
        return controller
    }
    
    
    private func comments() -> [CellControllerProtocol] {
        let commentStubs = [
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                    date: "1 year ago",
                    username: "A very very extremely long username"
                )
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "East Side Gallery\nMemorial in Berlin, Germany",
                    date: "10 days ago",
                    username: "A username"
                )
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "Chido carnal",
                    date: "5 hours ago",
                    username: "Another username"
                )
            )
        ]
        
        return commentStubs
    }
}
