//
//  TaskDetailsConfigurator.swift
//  ToDo List
//
//  Created by Ilyas on 30.11.2024.
//

import Foundation

protocol TaskDetailsConfiguratorInputProtocol {
  func configure(withView view: TaskDetailsViewController,
                 delegate: TaskDetailsViewControllerDelegate?,
                 task: Task?,
                 taskId: Int?
  )
}

final class TaskDetailsConfigurator: TaskDetailsConfiguratorInputProtocol {
  func configure(
    withView view: TaskDetailsViewController,
    delegate: TaskDetailsViewControllerDelegate?,
    task: Task?,
    taskId: Int?
  ) {
    
    let presenter = TaskDetailsPresenter(view: view)
    let interactor = TaskDetailsInteractor(
      presenter: presenter,
      task: task,
      taskId: taskId,
      delegate: delegate
    )
    let router = TaskDetailsRouter(view: view)
    
    view.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }

}
