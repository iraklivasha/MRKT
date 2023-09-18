//
//  SignupView.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject private(set) var model : UserViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 12.0) {
            Text("Sign up").font(.largeTitle)
            
            BorderedTextInput(text: $model.username,
                              placeholder: "username",
                              validationError: $model.inlineErrorForUsername.wrappedValue)
            
            BorderedTextInput(text: $model.password,
                              placeholder: "password",
                              validationError: $model.inlineErrorForPassword.wrappedValue)
            
            HStack {
                Text("Age: ")
                Picker("Age", selection: $model.ageIndex) {
                    ForEach(Consts.AGE_RANGE, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.menu)
            }
            
            LoadingButton(loading: model.loading, title: "Sign up",
                          enabled: $model.isValid.wrappedValue,
                          action: {
                model.signup()
            })
            .disabled(!$model.isValid.wrappedValue)
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}



