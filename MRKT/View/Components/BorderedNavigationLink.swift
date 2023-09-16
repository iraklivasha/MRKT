//
//  BorderedNavigationLink.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct BorderedNavigationLink: View {
    
    let title: String
    let view: AnyView
    
    var body: some View {
        HStack(alignment: .center, spacing: 12, content: {
            NavigationLink {
                                view
                            } label: {
                                Text(title)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.black)
                            }
            .padding(8)
        })
        
        .clipShape(Capsule())
        .overlay(RoundedRectangle(cornerRadius: 12)
                 .stroke(Color.black, lineWidth: 2))
        
    }
}

