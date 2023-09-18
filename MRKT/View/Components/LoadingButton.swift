//
//  LoadingButton.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct LoadingButton: View {
    
    let loading: Bool
    let title: String
    let enabled: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12, content: {
            Button(title) {
                action()
            }
            .padding(.leading, 8)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .padding(.trailing, loading ? 0 : 8)
            .foregroundColor(enabled ? .white : .red)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding(EdgeInsets(top: 8,
                                    leading: loading ? 2 : CGFloat.leastNonzeroMagnitude,
                                    bottom: 8,
                                    trailing: loading ? 8 : CGFloat.leastNonzeroMagnitude)).modifier(EmptyModifier(isEmpty: !loading))
        })
        .background(enabled ? .red : .white)
        .border(.red, width: 2, cornerRadius: 0)
    }
}
