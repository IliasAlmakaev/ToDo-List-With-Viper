//
//  TaskDetailsRouter.swift
//  ToDo List
//
//  Created by Ilyas on 30.11.2024.
//

import Foundation

protocol TaskDetailsRouterInputProtocol {
  init(view: TaskDetailsViewController)
  func dismiss()
}

final class TaskDetailsRouter: TaskDetailsRouterInputProtocol {
  private unowned let view: TaskDetailsViewController
  
  required init(view: TaskDetailsViewController) {
    self.view = view
  }
  
  func dismiss() {
    view.dismiss(animated: true, completion: nil)
  }
}
