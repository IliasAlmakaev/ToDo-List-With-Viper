//
//  TaskListInteractor.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

protocol TaskListInteractorInputProtocol {
  func fetchTasks()
  func checkTask(with dataStore: TaskListDataStore)
  func deleteTask(with dataStore: TaskListDataStore)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
  func tasksDidReceive(with dataStore: TaskListDataStore)
  func checkTask(with dataStore: TaskListDataStore)
}

final class TaskListInteractor: TaskListInteractorInputProtocol {
  
  private unowned let presenter: TaskListInteractorOutputProtocol
  private let storageManager = StorageManager.shared
  
  required init(presenter: TaskListInteractorOutputProtocol) {
    self.presenter = presenter
  }
  
  func fetchTasks() {
    let isNotFirstFetchTasks = UserDefaults.standard.bool(forKey: "isNotFirstFetchTasks")
    
    if !isNotFirstFetchTasks {
      fetchTodosFromNetwork()
    } else {
      fetchTodosFromCoreData()
    }
  }
  
  func checkTask(with dataStore: TaskListDataStore) {
    guard let task = dataStore.task else { return }
    var completed = task.completed
    completed.toggle()
    storageManager.checkTask(task, completed: completed)
    presenter.checkTask(with: dataStore)
  }
  
  func deleteTask(with dataStore: TaskListDataStore) {
    guard let task = dataStore.task else { return }
    storageManager.delete(task)
  }
  
  private func saveTodos(_ todos: [Todo]) {
    var tasks = [Task]()
    
    todos.forEach { todo in
      let taskId = Int16(todo.id)
      let title = todo.todo
      let completed = todo.completed
      
      storageManager.createTask(
        withID: taskId,
        todo: title,
        creationDate: Date(),
        completed: completed
      ) { task in
        tasks.append(task)
      }
    }
    
    let dataStore = TaskListDataStore(tasks: tasks)
    presenter.tasksDidReceive(with: dataStore)
  }
  
  private func fetchTodosFromNetwork() {
    NetworkManager.shared.fetchData { [unowned self] result in
      UserDefaults.standard.set(true, forKey: "isNotFirstFetchTasks")
      switch result {
      case .success(let todos):
        saveTodos(todos)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func fetchTodosFromCoreData() {
    storageManager.fetchData { result in
      switch result {
      case .success(let tasks):
        let dataStore = TaskListDataStore(tasks: tasks)
        presenter.tasksDidReceive(with: dataStore)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
