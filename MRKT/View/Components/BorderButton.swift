//
//  BorderButton.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct BorderButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12, content: {
            Button(action: {
                action()
            }) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
            }

            .padding(8)
            .foregroundColor(.black)
        })
        .clipShape(Capsule())
        .overlay(RoundedRectangle(cornerRadius: 12)
                 .stroke(Color.black, lineWidth: 2))
        
    }
}
