//
//  BaseRequest.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Foundation

class BaseRequest {
    
    var params: Any? {
        return [String:Any]()
    }
    
    var dictionaryParams: [String: Any]? {
        return self.params as? [String: Any]
    }
}
