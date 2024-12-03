//
//  TaskListViewController.swift
//  ToDo List
//
//  Created by Ilyas on 21.11.2024.
//

import UIKit

protocol TaskListViewInputProtocol: AnyObject {
  func reloadData(for rows: [TaskCellViewModel])
  func setTaskCount(withText text: String)
  func addTask(for row: TaskCellViewModel)
  func updateTask(for row: TaskCellViewModel, withIndexRow indexRow: Int)
}

protocol TaskListViewOutputProtocol {
  func viewDidLoad()
  func createTaskButtonPressed()
  func addTask(_ task: Task)
  func editTask(withIndexRow indexRow: Int)
  func updateTask(_ task: Task)
}

protocol TaskDetailsViewControllerDelegate: AnyObject {
  func saveTask(_ task: Task)
  func editTask(_ task: Task)
}

final class TaskListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var taskCountLabel: UILabel!
  
  var presenter: TaskListViewOutputProtocol!
  
  private let configurator: TaskListConfiguratorInputProtocol = TaskListConfigurator()
  private var activityIndicator: UIActivityIndicatorView?
  private var rows: [TaskCellViewModelProtocol] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(withView: self)
    activityIndicator = showActivityIndicator(in: view)
    presenter.viewDidLoad()
  }
  
  @IBAction func createTaskButtonPressed() {
    presenter.createTaskButtonPressed()
  }
  
  private func showActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .white
    activityIndicator.startAnimating()
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    
    view.addSubview(activityIndicator)
    
    return activityIndicator
  }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellViewModel = rows[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
    guard let cell = cell as? TaskCell else { return UITableViewCell() }
    cell.viewModel = cellViewModel
    return cell
  }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    rows[indexPath.row].cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  func tableView(
    _ tableView: UITableView,
    contextMenuConfigurationForRowAt indexPath: IndexPath,
    point: CGPoint
  ) -> UIContextMenuConfiguration? {
    
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { menuElements in
      
      let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { [unowned self] action in
        presenter.editTask(withIndexRow: indexPath.row)
      }
      
      let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { action in
        
      }
      
      let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [editAction, deleteAction])
      
      return menu
    }
    
    return configuration
  }
}


// MARK: - TaskListViewInputProtocol
extension TaskListViewController: TaskListViewInputProtocol {
  func reloadData(for rows: [TaskCellViewModel]) {
    self.rows = rows
    tableView.reloadData()
    activityIndicator?.stopAnimating()
  }
  
  func setTaskCount(withText text: String) {
    taskCountLabel.text = text
  }
  
  func addTask(for row: TaskCellViewModel) {
    rows.append(row)
    tableView.reloadData()
  }
  
  func updateTask(for row: TaskCellViewModel, withIndexRow indexRow: Int) {
    rows[indexRow] = row
    tableView.reloadData()
  }
}

// MARK: - TaskDetailsViewControllerDelegate
extension TaskListViewController: TaskDetailsViewControllerDelegate {
  func saveTask(_ task: Task) {
    presenter.addTask(task)
  }
  
  func editTask(_ task: Task) {
    presenter.updateTask(task)
  }
}

