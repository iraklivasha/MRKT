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
            BorderedTextInput(text: $model.username,
                              placeholder: "Email",
                              validationError: $model.inlineErrorForUsername.wrappedValue)
            
            BorderedTextInput(text: $model.password,
                              placeholder: "Password",
                              validationError: $model.inlineErrorForPassword.wrappedValue)
            LoadingButton(loading: model.loading,
                          title: "Log in",
                          enabled: $model.isValid.wrappedValue,
                          action: {
                            model.login()
                          })
            .disabled(!$model.isValid.wrappedValue)
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}


