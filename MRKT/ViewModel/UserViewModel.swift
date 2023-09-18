//
//  LoginViewModel.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 15.09.23.
//

import Combine
import Foundation

class UserViewModel: ObservableObject {
    
    private var publishers = Set<AnyCancellable>()
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var ageIndex = 0
    @Published var inlineErrorForUsername: String?
    @Published var inlineErrorForPassword: String?
    @Published var isValid: Bool = false
    
    @Published private(set) var loading = false
    @Published private(set) var isLoggedIn = false
    
    private let api: UserAPIProtocol
    
    init(api: UserAPIProtocol = UserAPI()) {
        self.api = api
        self.prepareValidators()
    }
    
    private func prepareValidators() {
        isUsernameValidPublisher
            .dropFirst(2)
            .receive(on: RunLoop.main)
            .map {
                return $0 ? nil : "Username is invalid"
                
            }
            .assign(to: \.inlineErrorForUsername, on: self)
            .store(in: &publishers)
        
        isPasswordValidPublisher
            .dropFirst(2)
            .receive(on: RunLoop.main)
            .map {
                return $0 ? nil : "Password is invalid"
                
            }
            .assign(to: \.inlineErrorForPassword, on: self)
            .store(in: &publishers)
        
        isValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &publishers)
    }
    
    func login() {
        loading = true
        let subscription = self.api.login(username: username, passwrod: password)
            .task
            .sink { completion in
                switch completion {
                    case .finished:
                        print("login success")
                        break
                    case .failure(let error):
                        print("error:\(error)")
                        break
                }

        } receiveValue: {[weak self] resp in
            self?.userResponseCompletion(resp: resp)
        }
        
        subscription.store(in: &publishers)
    }
    
    func signup() {
        loading = true
        self.api.signup(username: username,
                        passwrod: password,
                        age: ageIndex + Consts.AGE_RANGE.lowerBound)
            .task
            .sink { completion in
                switch completion {
                    case .finished:
                        print("signup success")
                        break
                    case .failure(let error):
                        print("error:\(error)")
                        break
                }

        } receiveValue: {[weak self] resp in
            self?.userResponseCompletion(resp: resp)
        }.store(in: &publishers)
    }
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
              .map { email in
                  return Consts.emailPredicate.evaluate(with: email)
              }
              .eraseToAnyPublisher()
      }
      
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
          $password
              .map { password in
                  return password.count >= Consts.PASS_MIN_CHARS && password.count <= Consts.PASS_MAX_CHARS
              }
              .eraseToAnyPublisher()
      }
    
    private var isValidPublisher: AnyPublisher<Bool, Never> {
          Publishers.CombineLatest(
              isUsernameValidPublisher,
              isPasswordValidPublisher)
              .map { isEmailValid, isPasswordValid in
                  return isEmailValid && isPasswordValid
              }
              .eraseToAnyPublisher()
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
