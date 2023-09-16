//
//  PhotoAPI.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Foundation

protocol PhotoAPIProtocol: AnyObject {
    func fetch() -> APIRequest<MRKTResponse<[Photo]>>
}

class PhotoAPI: BaseAPI, PhotoAPIProtocol {
    func fetch() -> APIRequest<MRKTResponse<[Photo]>> {
        let endpoint = Router.photo.fetch(request: BaseRequest())
        return super.request(endpoint: endpoint)
    }
}
