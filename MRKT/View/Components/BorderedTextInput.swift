//
//  BorderedTextInput.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct BorderedTextInput: View {
    let text: Binding<String>
    let placeholder: String
    var body: some View {
        TextField(placeholder, text: text)
            .frame(height: 55)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                .padding([.horizontal], 24)
    }
}
