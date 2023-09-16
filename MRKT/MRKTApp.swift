//
//  MRKTApp.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import SwiftUI

@main
struct MRKTApp: App {
    
    @StateObject var vm = UserViewModel()

    var body: some Scene {
        WindowGroup {
            if (vm.isLoggedIn) {
                HomeView(loginVM: vm)
            } else {
                OnboardingView(userVM: vm)
            }
        }
    }
}
