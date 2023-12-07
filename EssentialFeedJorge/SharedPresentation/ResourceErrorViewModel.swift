//
//  ResourceErrorViewModel.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 07/12/23.
//


public struct ResourceErrorViewModel {
    public let message: String?
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
