//
//  Todo.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

struct Results: Decodable {
  let todos: [Todo]
}

struct Todo: Decodable {
  let id: Int
  let todo: String
  let completed: Bool
}
