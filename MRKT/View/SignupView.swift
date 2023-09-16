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
            TextField("username", text: $model.username)
                .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.horizontal], 24)
            TextField("password", text: $model.password)
                .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding([.horizontal], 24)
            HStack {
                Text("Age: ")
                Picker("Age", selection: $model.ageIndex) {
                    ForEach(18 ..< 100) { number in
                                            Text("\(number)")
                                        }
                }
                .pickerStyle(.menu)
            }
            LoadingButton(loading: model.loading, title: "Sign up", action: {
                model.signup()
            }).frame(width: 120, height: 54, alignment: .center)
        }
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}



