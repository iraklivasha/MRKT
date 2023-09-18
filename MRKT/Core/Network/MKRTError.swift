//
//  MKRTError.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Foundation

enum MRKTError: Error {
    case sessionFailed(error: URLError)
    case decodingFailed
    case other(Error)
}
