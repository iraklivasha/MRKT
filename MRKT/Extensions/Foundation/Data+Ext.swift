//
//  Data+Ext.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//


import Foundation

extension Data {
    var dictionary: [String: Any] {
      guard let dictionary = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] else {
        return [:]
      }
      return dictionary
    }
    
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
