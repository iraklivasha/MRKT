//
//  HomeViewModel.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    @Published private(set) var items: [Photo] = []
    @Published private(set) var error: MRKTError?
    
    private let api: PhotoAPIProtocol
    private var subscription: AnyCancellable?
    
    init(api: PhotoAPIProtocol = PhotoAPI()) {
        self.api = api
        self.fetch()
    }
    
    func fetch() {
        subscription = self.api.fetch()
            .task
            .replaceError(with: [])
            .assign(to: \.items, on: self)
    }
    
    func fetch1() {
        subscription = self.api.fetch()
            .task
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint("Photos fetched")
                    break
                case .failure(let e):
                    debugPrint("Error: \(e)")
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.items = result
            })
    }
}
