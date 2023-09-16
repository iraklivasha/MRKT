//
//  NetworkMock.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Foundation
import Netjob
import Combine

class NetworkMock: Network {
    
    private lazy var jsonObject = [String: Any]()
    private lazy var stringResponse = ""
    
    init(mockURL: URL) {
        if let data = try? Data(contentsOf: mockURL) {
            self.jsonObject = data.dictionary
        }
    }
    
    init(file: String, ext: String = "json", fromBundle bundle: Bundle = Bundle.main) {
        if let url = bundle.url(forResource: file, withExtension: ext),
            let data = try? Data(contentsOf: url) {
            self.jsonObject = data.dictionary
        }
    }
    
    init(stringResponse: String) {
        self.stringResponse = stringResponse
    }
    
    @discardableResult func request(endpoint: Endpoint) -> NetworkRequest {
        return NetworkRequest(publisher: apiResponse())
    }
    
    func apiResponse() -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
            let response = HTTPURLResponse()
            let data = self.jsonObject.data
            return Just((data: data, response: response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
    }

}
