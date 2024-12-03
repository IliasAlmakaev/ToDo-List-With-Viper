//
//  TaskDetailsInteractor.swift
//  ToDo List
//
//  Created by Ilyas on 30.11.2024.
//

import Foundation

protocol TaskDetailsInteractorInputProtocol {
  func setupUI()
  func createTask(
    title: String,
    descriptionText: String?,
    creationDate: Date,
    completed: Bool
  )
  func editTask(title: String, descriptionText: String?)
}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
  func setupUI(with dataStore: TaskDetailsDataStore)
  func dismiss()
}

final class TaskDetailsInteractor: TaskDetailsInteractorInputProtocol {
  
  private unowned let presenter: TaskDetailsInteractorOutputProtocol
  private let storageManager = StorageManager.shared
  
  private var task: Task?
  private var taskId: Int?
  private weak var delegate: TaskDetailsViewControllerDelegate?
  
  required init(
    presenter: TaskDetailsInteractorOutputProtocol,
    task: Task?,
    taskId: Int?,
    delegate: TaskDetailsViewControllerDelegate?
  ) {
    
    self.presenter = presenter
    self.task = task
    self.taskId = taskId
    self.delegate = delegate
  }
  
  func setupUI() {
    let taskDetailsDataStore = TaskDetailsDataStore(
      isCreateTask: taskId != nil,
      dateText: task?.creationDate ?? Date(),
      task: task
    )
    
    presenter.setupUI(with: taskDetailsDataStore)
  }
  
  func createTask(
    title: String,
    descriptionText: String?,
    creationDate: Date,
    completed: Bool
  ) {
    
    storageManager.createTask(
      withID: Int16(taskId ?? 0),
      todo: title,
      fullDescription: descriptionText,
      creationDate: creationDate,
      completed: completed
    ) { task in
      delegate?.saveTask(task)
      presenter.dismiss()
    }
  }
  
  func editTask(title: String, descriptionText: String?) {
    guard let task = task,
          title != task.todo || descriptionText != task.fullDescription else { return }
    
    storageManager.editTaskText(task, title: title, description: descriptionText ?? "")
    delegate?.editTask(task)
  }
}
