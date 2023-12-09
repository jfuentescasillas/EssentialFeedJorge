//
//  ImageCommentsPresenter.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 09/12/23.
//


import Foundation


public final class ImageCommentsPresenter {
    public static var title: String {
        let localizedString = NSLocalizedString(
            "IMAGE_COMMENTS_VIEW_TITLE",
            tableName: "ImageComments",
            bundle: Bundle(for: Self.self),
            comment: "Title for the image comments view")
        
        return localizedString
    }
}
