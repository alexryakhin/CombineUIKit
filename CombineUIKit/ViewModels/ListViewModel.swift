//
//  ListViewModel.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/24/22.
//

import Combine

final class ListViewModel: ObservableObject {
    let networkManager = NetworkManager.shared
    @Published var todos: [TodoItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        networkManager.getResults()
            .sink { error in
                // error handling
            } receiveValue: { [weak self] result in
                self?.todos = result
            }
            .store(in: &cancellables)
    }
    
}
