//
//  NetworkManager.swift
//  ToDo List
//
//  Created by Ilyas on 21.11.2024.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
}

final class NetworkManager {
  static let shared = NetworkManager()
  
  private let api = "https://dummyjson.com/todos"
  
  private init() {}
  
  func fetchData(completion: @escaping(Result<[Todo], NetworkError>) -> Void) {
    guard let url = URL(string: api) else {
      completion(.failure(.invalidURL))
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data else {
        completion(.failure(.noData))
        print(error?.localizedDescription ?? "No error description")
        return
      }
      do {
        let results = try JSONDecoder().decode(Results.self, from: data)
        DispatchQueue.main.async {
          completion(.success(results.todos))
        }
      } catch {
        completion(.failure(.decodingError))
      }
    }.resume()
  }
}
