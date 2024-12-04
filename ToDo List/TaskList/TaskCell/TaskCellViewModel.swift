//
//  TaskCellViewModel.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

protocol TaskCellViewModelProtocol {
  var cellIdentifier: String { get }
  var cellHeight: Double { get }
  var todo: String { get }
  var fullDescription: String? { get }
  var date: String { get }
  var completed: Bool { get }
  var task: Task { get }
  var delegate: TaskCellDelegate? { get set }
  init(task: Task)
}

final class TaskCellViewModel: TaskCellViewModelProtocol {
  var cellIdentifier: String {
    "TaskCell"
  }
  
  var cellHeight: Double {
    100
  }
  
  var todo: String {
    task.todo ?? ""
  }
  
  var fullDescription: String? {
    task.fullDescription
  }
  
  var date: String {
    task.creationDate?.formattedDate ?? ""
  }
  
  var completed: Bool {
    task.completed
  }
  
  let task: Task
  var delegate: TaskCellDelegate?
  
  init(task: Task) {
    self.task = task
  }
}
