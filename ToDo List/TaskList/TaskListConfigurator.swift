//
//  TaskListConfigurator.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

protocol TaskListConfiguratorInputProtocol {
  func configure(withView view: TaskListViewController)
}

final class TaskListConfigurator: TaskListConfiguratorInputProtocol {
  func configure(withView view: TaskListViewController) {
    let presenter = TaskListPresenter(view: view)
    let interactor = TaskListInteractor(presenter: presenter)
    let router = TaskListRouter(view: view)
    
    view.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
}
