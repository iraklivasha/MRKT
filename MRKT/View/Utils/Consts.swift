//
//  Consts.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 18.09.23.
//

import Foundation

struct Consts {
    static let PASS_MIN_CHARS = 6
    static let PASS_MAX_CHARS = 12
    static let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    static let AGE_RANGE = 18..<100
}
