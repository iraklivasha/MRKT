//
//  LoginView.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var model : UserViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 12.0) {
            Text("Log in").font(.largeTitle)
            BorderedTextInput(text: $model.username, placeholder: "username")
            BorderedTextInput(text: $model.password, placeholder: "password")
            LoadingButton(loading: model.loading, title: "Log in", action: {
                model.login()
            }).frame(width: 120, height: 54, alignment: .center)
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}


