//
//  BaseAPI.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Foundation
import Netjob
import Combine

struct APIRequest<T: Codable> {
    public let task: AnyPublisher<T, Error>
    
    public init(task: AnyPublisher<T, Error>) {
        self.task = task
    }
}

class BaseAPI {
    func request<T: Codable>(endpoint: any MRKTEndpoint) -> APIRequest<T> {
        let publisher = endpoint
                        .request(endpoint: endpoint)
                        .publisher
                        .tryMap({ data, response in
                            return data
                        })
                        .decode(type: T.self, decoder: JSONDecoder())
                        .eraseToAnyPublisher()
        
        return APIRequest(task: publisher)
    }
}
