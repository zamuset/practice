//
//  DBErrorType.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 19/06/24.
//

import Foundation

enum DBErrorType: LocalizedError {
    case invalidRequest
    case entityNotFound
    case invalidMatch
    case dbError(error: NSError)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid Request"
        case .entityNotFound:
            return "Entity not found"
        case .invalidMatch:
            return "Information doesn't match"
        case .dbError(let error):
            return error.localizedDescription
        case .unknown:
            return "Unknown Error"
        }
    }
}
