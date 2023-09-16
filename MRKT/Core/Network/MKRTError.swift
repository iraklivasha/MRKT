//
//  MKRTError.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Foundation

protocol MKRTErrorProtocol: Error {
    var code: Int { get }
    var message: String { get }
    var nsError: NSError { get }
    var userInfo: [String: Any]? { get }
}


enum MKRTError: Error, MKRTErrorProtocol, Codable
{
    
    case unknown
    case notfound
    case forbidden
    case server
    case uploadFailed
    case userCancelled
    case unauthorized
    case invalidContent
    case cancelled
    
    init(rawValue: Int) {
        self = MKRTError.error(from: rawValue)
    }
    
    private static func error(from code: Int) -> MKRTError {
        switch code {
        case MKRTError.notfound.code: return MKRTError.notfound
        case MKRTError.forbidden.code: return MKRTError.forbidden
        case MKRTError.server.code: return MKRTError.server
        case MKRTError.userCancelled.code: return MKRTError.userCancelled
        case MKRTError.unauthorized.code: return MKRTError.unauthorized
        case MKRTError.invalidContent.code: return MKRTError.invalidContent
        case MKRTError.uploadFailed.code: return MKRTError.uploadFailed
        case MKRTError.cancelled.code: return MKRTError.cancelled
        default: return MKRTError.unknown
        }
    }
    
    var message: String {
        switch self {
        case .unknown:          return "Something went wrong"
        case .notfound:         return "Resource not found"
        case .forbidden:        return "Forbidden"
        case .server:           return "Server error"
        case .userCancelled:    return "Operation cancelled"
        case .unauthorized:     return "Unauthorized access"
        case .invalidContent:   return "Invalid content"
        case .uploadFailed:     return "Upload failed"
        case .cancelled:        return "Cancelled"
        }
    }

    var code: Int {
        switch self {
        case .unknown:          return 1000
        case .notfound:         return 400
        case .forbidden:        return 403
        case .server:           return 500
        case .userCancelled:    return 999
        case .unauthorized:     return 401
        case .invalidContent:   return 998
        case .uploadFailed:     return 1002
        case .cancelled:        return -999
        }
    }

    var userInfo: [String: Any]? {
        return ["code": code, "description": message]
    }
    
    var nsError: NSError {
        return NSError(domain: "com.mkrt", code: code, userInfo: userInfo)
    }
}
