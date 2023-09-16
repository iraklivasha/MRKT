//
//  EmptyViewModifier.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct EmptyModifier: ViewModifier {

    let isEmpty: Bool

    func body(content: Content) -> some View {
        Group {
            if isEmpty {
                EmptyView()
            } else {
                content
            }
        }
    }
}
