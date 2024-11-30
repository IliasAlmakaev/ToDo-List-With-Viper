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
}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
  func setupUI(with dataStore: TaskDetailsDataStore)
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
      dateText: Date().formattedDate
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
    ) { [weak self] task in
      
    }
  }
}
