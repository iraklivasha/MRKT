//
//  LoginRequest.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Foundation

class LoginRequest: BaseRequest {
    
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    override var params: Any? {
        return (super.params as? [String: Any])?.union([
            "username": self.username,
            "password": self.password
        ])
    }
}
