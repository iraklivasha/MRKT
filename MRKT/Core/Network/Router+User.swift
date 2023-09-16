//
//  Router+User.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Netjob

extension Router {
    
    enum user: MRKTEndpoint {
        var path: String {
            switch self {
            case .login(request: _):
                return "/login"
            case .signup(request: _):
                return "/signup"
            }
        }
        
        static var allCases: [Router.user] {
            [
                .login(request: BaseRequest()),
                .signup(request: BaseRequest())
            ]
        }
        
        var mockPath: String? {
            return "login-resp"
        }
        
        var method: HTTPMethod { return .post }
        case login(request: BaseRequest)
        case signup(request: BaseRequest)
    }
}
