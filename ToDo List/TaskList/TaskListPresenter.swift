//
//  TaskListPresenter.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

struct TaskListDataStore {
  var tasks: [Task]
  var selectedIndexRow: Int? = nil
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
  
  func addTask(_ task: Task) {
    dataStore?.tasks.append(task)
    let row = TaskCellViewModel(task: task)
    view.addTask(for: row)
    setTaskCount(dataStore?.tasks.count ?? 0)
  }
  
  func editTask(withIndexRow indexRow: Int) {
    let task = dataStore?.tasks[indexRow]
    dataStore?.selectedIndexRow = indexRow
    router.openTaskDetailsViewController(with: task, taskId: nil)
  }
  
  func updateTask(_ task: Task) {
    guard let selectedIndexRow = dataStore?.selectedIndexRow else { return }
    let row = TaskCellViewModel(task: task)
    dataStore?.tasks[selectedIndexRow] = task
    view.updateTask(for: row, withIndexRow: selectedIndexRow)
  }
  
  private func setTaskCount(_ taskCount: Int) {
    let taskCountText = "\(taskCount) задач (и)"
    view.setTaskCount(withText: taskCountText)
  }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
  func tasksDidReceive(with dataStore: TaskListDataStore) {
    self.dataStore = dataStore
    let rows: [TaskCellViewModel] = dataStore.tasks.map { TaskCellViewModel(task: $0) }
    
    view.reloadData(for: rows)
    setTaskCount(rows.count)
  }
}
