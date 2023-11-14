//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeedJorge
//
//  Created by jfuentescasillas on 14/11/23.
//


import Foundation


extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
