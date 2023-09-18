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
    public let task: AnyPublisher<T, MRKTError>
    
    public init(task: AnyPublisher<T, MRKTError>) {
        self.task = task
    }
}

class BaseAPI {
    
    func request<T: Codable>(endpoint: any MRKTEndpoint) -> APIRequest<T> {
        let publisher = endpoint
                        .request(endpoint: endpoint)
                        .publisher
                        .map(\.data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError({ error in
                                switch error {
                                case is Swift.DecodingError:
                                  return MRKTError.decodingFailed
                                default:
                                    return MRKTError.other(error)
                                }
                            
                            // ეს მაგალითისთვის - აქ შესაძლებელია უფრო მეტი კონკრეტიკის შემოტანა ერორებზე (დამოკიდებულია ლოგიკაზე, თუ რა ტიპის ერორებს როგორ დაჰენდლავს აპი, შესაბამისად ამ ენამსაც მეტი ქეისები ექნება)
                              })
                        .eraseToAnyPublisher()
        
        return APIRequest(task: publisher)
    }
}
