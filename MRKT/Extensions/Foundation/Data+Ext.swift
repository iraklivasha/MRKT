//
//  Data+Ext.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//


import Foundation

extension Data {
    
    var object: Any? {
      guard let object = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) else {
        return nil
      }
      return object
    }
    
    var dictionary: [String: Any] {
      guard let dictionary = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] else {
        return [:]
      }
      return dictionary
    }
    
    var array: [Any] {
      guard let array = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [Any] else {
        return []
      }
      return array
    }
    
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
