//
//  TaskListRouter.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation
import UIKit

protocol TaskListRouterInputProtocol {
  init(view: TaskListViewController)
  func openTaskDetailsViewController(with task: Task?, taskId: Int?)
}

final class TaskListRouter: TaskListRouterInputProtocol {
  private unowned let view: TaskListViewController
  
  required init(view: TaskListViewController) {
    self.view = view
  }
  
  func openTaskDetailsViewController(with task: Task?, taskId: Int?) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let taskDetailsVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController else { return}
    
    let configurator: TaskDetailsConfiguratorInputProtocol = TaskDetailsConfigurator()
    configurator.configure(withView: taskDetailsVC, delegate: view, task: task, taskId: taskId)
    
    view.navigationController?.pushViewController(taskDetailsVC, animated: true)
  }
}
