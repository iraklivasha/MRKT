//
//  Onboarding.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var userVM : UserViewModel
    
    var body: some View {
        @State var isLinkActive = false
        
        NavigationView {
            VStack {
                Image(systemName: "staroflife.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Spacer()
                Text("Welcome to MRKT!").font(.largeTitle)
                Spacer()
                BorderedNavigationLink(title: "Log in", view: AnyView(LoginView(model: userVM)))
                BorderedNavigationLink(title: "Sign up", view: AnyView(SignupView(model: userVM)))
                
            }
            .padding()
        }
    }
}
