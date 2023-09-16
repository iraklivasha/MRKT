//
//  Photo.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Foundation

struct Photo: Codable, Identifiable {
    let id: String
    let url: String
    let size: String
    let type: String
    let tags: [String]
    let author: String
    let viewCount: Int
    let likeCount: Int
    let commentsCount: Int
    let favCount: Int
    let downloadCount: Int
}

extension Photo {
    var nsURL: URL {
        return URL(string: url)!
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
