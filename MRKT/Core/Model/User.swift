//
//  User.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let age: Int
    
    static var instance: User?
    
    static var isLoggedIn: Bool {
        return User.instance != nil
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.username.lowercased() == rhs.username.lowercased()
    }
}
