//
//  SignupRequest.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Foundation

class SignupRequest: LoginRequest {
    
    let age: Int
    
    init(username: String, password: String, age: Int) {
        self.age = age
        super.init(username: username, password: password)
    }
    
    override var params: Any? {
        return (super.params as? [String: Any])?.union([
            "age": self.age
        ])
    }
}
