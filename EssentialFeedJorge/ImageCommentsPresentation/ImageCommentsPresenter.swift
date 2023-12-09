//
//  ImageCommentsPresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 09/12/23.
//


import Foundation


// MARK: - ImageCommentViewModel and ImageCommentViewModels
public struct ImageCommentsViewModel {
    public let comments: [ImageCommentViewModel]
}


public struct ImageCommentViewModel: Equatable {
    public let message: String
    public let date: String
    public let username: String
    
    
    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}


// MARK: - Class. ImageCommentsPresenter
public final class ImageCommentsPresenter {
    public static var title: String {
        let localizedString = NSLocalizedString(
            "IMAGE_COMMENTS_VIEW_TITLE",
            tableName: "ImageComments",
            bundle: Bundle(for: Self.self),
            comment: "Title for the image comments view")
        
        return localizedString
    }
    
    
    public static func map(_ comments: [ImageComment], currentDate: Date = Date(), calendar: Calendar = .current, locale: Locale = .current) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        
        let imageCommentsViewModel = ImageCommentsViewModel(
            comments: comments.map { comment in
                ImageCommentViewModel(
                    message: comment.message,
                    date: formatter.localizedString(for: comment.createdAt, relativeTo: currentDate),
                    username: comment.username)
            }
        )
        
        return imageCommentsViewModel
    }
}
