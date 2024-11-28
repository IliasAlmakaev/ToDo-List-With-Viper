//
//  TaskListRouter.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

protocol TaskListRouterInputProtocol {
  init(view: TaskListViewController)
}

final class TaskListRouter: TaskListRouterInputProtocol {
  private unowned let view: TaskListViewController
  
  required init(view: TaskListViewController) {
    self.view = view
  }
}
