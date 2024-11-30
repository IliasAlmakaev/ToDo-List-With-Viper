//
//  TaskListPresenter.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

struct TaskListDataStore {
  let tasks: [Task]
}

final class TaskListPresenter: TaskListViewOutputProtocol {
  
  var interactor: TaskListInteractorInputProtocol!
  var router: TaskListRouterInputProtocol!
  
  private unowned let view: TaskListViewInputProtocol
  private var dataStore: TaskListDataStore?
  
  required init(view: TaskListViewInputProtocol) {
    self.view = view
  }
  
  func viewDidLoad() {
    interactor.fetchTasks()
  }
  
  func createTaskButtonPressed() {
    let lastTaskId = dataStore?.tasks.last?.id ?? 0
    let creationTaskId = lastTaskId != 0 ? lastTaskId + 1 : 0
    router.openTaskDetailsViewController(with: nil, taskId: Int(creationTaskId))
  }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
  func tasksDidReceive(with dataStore: TaskListDataStore) {
    self.dataStore = dataStore
    let rows: [TaskCellViewModel] = dataStore.tasks.map { TaskCellViewModel(task: $0) }
    let taskCountText = "\(rows.count) задач (и)"
    
    view.reloadData(for: rows)
    view.setTaskCount(withText: taskCountText)
  }
}
