//
//  LoginAPI.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Foundation

protocol UserAPIProtocol: AnyObject {
    func login(username: String, passwrod: String) -> APIRequest<User>
    func signup(username: String, passwrod: String, age: Int) -> APIRequest<User>
}

class UserAPI: BaseAPI, UserAPIProtocol {
    
    func login(username: String, passwrod: String) -> APIRequest<User> {
        let endpoint = Router.user.login(request: LoginRequest(username: username,
                                                               password: passwrod))
        return super.request(endpoint: endpoint)
    }
    
    func signup(username: String, passwrod: String, age: Int) -> APIRequest<User> {
        let endpoint = Router.user.signup(request: SignupRequest(username: username,
                                                                 password: passwrod,
                                                                 age: age))
        return super.request(endpoint: endpoint)
    }
}
