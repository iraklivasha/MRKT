//
//  Endpoint.swift
//  Netjob
//
//  Created by Irakli Vashakidze on 01/06/2020.
//  Copyright © 2020. All rights reserved.
//

import Foundation

/// Server endpoint interface, any server router should implement this interface to be able to connect
public protocol Endpoint {

    /// The last path component to the endpoint. will be appended to the base url in the service
    var url: String { get }

    /// The encoded parameters
    var parameters: Any? { get }
    
    /// The encoded parameters
    var urlParameters: [String: String]? { get }

    /// The HTTP headers to be appended in the request, default is nil
    var headers: [String: String]? { get }

    /// Http method as specified by the server
    var method: HTTPMethod { get }
    
    /// How long (in seconds) a task should wait for additional data to arrive. The timer is reset whenever new data arrives.
    var timeout: TimeInterval { get }
    
    /// Caching policy for the endpoint
    var cachePolicy: URLRequest.CachePolicy { get }
    
    var requestContentType: String { get }
    
    var network: Network { get }
}

public extension Endpoint {
    
    var timeout: TimeInterval {
        return 30
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
    
    var requestContentType: String {
        return "application/json"
    }
    
    var network: Network {
        return NetworkService.shared
    }
    
    @discardableResult func request(endpoint: Endpoint) -> NetworkRequest {
        self.network.request(endpoint: endpoint)
    }
}
