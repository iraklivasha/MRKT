//
//  HomeViewModel.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import Combine

class HomeViewModel: ObservableObject {
    
    @Published private(set) var items: [Photo] = []
    private let api: PhotoAPIProtocol
    
    init(api: PhotoAPIProtocol = PhotoAPI()) {
        self.api = api
    }
    
    func fetch() {
        _ = self.api.fetch()
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
            self?.items = resp.result ?? []
        }
    }
}
