//
//  MainViewModel.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Combine

final class MainViewModel: ObservableObject {
//    let textSubject = CurrentValueSubject<String, Never>("Hello")
    @Published var textSubject = "Hello"
}
