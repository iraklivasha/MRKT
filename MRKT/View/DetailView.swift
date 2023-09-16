//
//  DetailView.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import SwiftUI

struct TaskRow: View {
    
    let text: String
    var body: some View {
        Text(text)
    }
}

struct DetailView: View {
    
    let item: Photo
    
    var body: some View {
        List {
            Section(header: Text("Photo details")) {
                AsyncImage(url: item.nsURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                
                TaskRow(text: "Size: \(item.size)")
                TaskRow(text: "Type: \(item.type)")
                TaskRow(text: "Tags: \(item.tags.map({ "#\($0)" }).joined(separator: ","))")
            }

            Section(header: Text("Other details")) {
                TaskRow(text: "Author: \(item.author)")
                TaskRow(text: "Views: \(item.viewCount)")
                TaskRow(text: "Likes: \(item.likeCount)")
                TaskRow(text: "Comments: \(item.commentsCount)")
                TaskRow(text: "Favourites: \(item.favCount)")
                TaskRow(text: "Downloads: \(item.downloadCount)")
            }
        }
    }
}
