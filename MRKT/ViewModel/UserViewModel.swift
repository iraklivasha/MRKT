//
//  LoginViewModel.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Combine
import Foundation

class UserViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var ageIndex = 0
    @Published private(set) var loading = false
    @Published private(set) var isLoggedIn = false
    let range = 18..<100
    private let api: UserAPIProtocol
    
    init(api: UserAPIProtocol = UserAPI()) {
        self.api = api
    }
    
    func login() {
        loading = true
        _ = self.api.login(username: username, passwrod: password)
            .task
            .sink { completion in
                switch completion {
                    case .finished:
                        print("finished")
                        break
                    case .failure(let error):
                        print("error:\(error)")
                        break
                }

        } receiveValue: {[weak self] resp in
            self?.userResponseCompletion(resp: resp.result)
        }
    }
    
    func signup() {
        loading = true
        _ = self.api.signup(username: username, passwrod: password, age: ageIndex + 18)
            .task
            .sink { completion in
                switch completion {
                    case .finished:
                        print("finished")
                        break
                    case .failure(let error):
                        print("error:\(error)")
                        break
                }

        } receiveValue: {[weak self] resp in
            self?.userResponseCompletion(resp: resp.result)
        }
    }
    
    private func userResponseCompletion(resp: User?) {
        User.instance = resp
        self.loading = false
        self.isLoggedIn = User.isLoggedIn
    }
    
    func logout() {
        User.instance = nil
        self.isLoggedIn = false
    }
}
