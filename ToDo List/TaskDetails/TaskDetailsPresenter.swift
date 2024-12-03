//
//  TaskDetailsPresenter.swift
//  ToDo List
//
//  Created by Ilyas on 29.11.2024.
//

import Foundation

struct TaskDetailsDataStore {
  let isCreateTask: Bool
  let dateText: Date
  var task: Task? = nil
}

final class TaskDetailsPresenter: TaskDetailsViewOutputProtocol {
  
  var interactor: TaskDetailsInteractorInputProtocol!
  var router: TaskDetailsRouter!
  
  private unowned let view: TaskDetailsViewInputProtocol
  
  init(view: TaskDetailsViewInputProtocol) {
    self.view = view
  }
  
  func viewDidLoad() {
    interactor.setupUI()
  }
  
  func createTask(
    title: String,
    descriptionText: String?,
    creationDate: Date,
    completed: Bool
  ) {
    
    interactor.createTask(
      title: title,
      descriptionText: descriptionText,
      creationDate: creationDate,
      completed: completed
    )
  }
  
  func editTask(title: String, descriptionText: String?) {
    interactor.editTask(title: title, descriptionText: descriptionText)
  }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
  func setupUI(with dataStore: TaskDetailsDataStore) {
    view.setupUI(
      isCreateTask: dataStore.isCreateTask,
      dateText: dataStore.dateText.formattedDate,
      title: dataStore.task?.todo,
      description: dataStore.task?.fullDescription
    )
  }
  
  func dismiss() {
    router.dismiss()
  }
}
