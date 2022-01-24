//
//  NetworkManager.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/24/22.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    var anyCancelable = Set<AnyCancellable>()
    private init() { }
    
    func getResults() -> Future<[TodoItem], Error> {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        let url = URL(string: urlString)!
        
        let decoder = JSONDecoder()
        
        return Future { [weak self] promise in
            guard let self = self else {return}
            URLSession.shared.dataTaskPublisher(for: url)
                .retry(1)
                .mapError {$0}
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [TodoItem].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    // handle error here
                } receiveValue: { jobs in
                    promise(.success(jobs))
                }
                .store(in: &self.anyCancelable)
        }
    }
}

struct TodoItem: Codable, Hashable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

/*
 {
 "userId": 1,
 "id": 4,
 "title": "et porro tempora",
 "completed": true
 }
 */
