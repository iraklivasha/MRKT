//
//  Router+Photo.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Netjob

extension Router {
    
    enum photo: MRKTEndpoint {
        var path: String {
            switch self {
            case .fetch(request: _):
                return "/fetch"
            }
        }
        
        static var allCases: [Router.photo] {
            [
                .fetch(request: BaseRequest())
            ]
        }
        
        var mockPath: String? {
            return "photos-resp"
        }
        
        var method: HTTPMethod { return .get }
        case fetch(request: BaseRequest)
    }
}
