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
  func updateTask(for row: TaskCellViewModel, withIndexPath indexPath: IndexPath)
}

protocol TaskListViewOutputProtocol {
  func viewDidLoad()
  func createTaskButtonPressed()
  func addTask(_ task: Task)
  func editTask(withIndexRow indexRow: Int)
  func updateTask(_ task: Task)
  func checkTask(_ task: Task, indexPath: IndexPath)
  func deleteTask(_ task: Task, indexRow: Int)
}

protocol TaskDetailsViewControllerDelegate: AnyObject {
  func saveTask(_ task: Task)
  func editTask(_ task: Task)
}

protocol TaskCellDelegate: AnyObject {
  func checkTask(withTask task: Task, andCell cell: TaskCell)
}

final class TaskListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var taskCountLabel: UILabel!
  
  var presenter: TaskListViewOutputProtocol!
  
  private let configurator: TaskListConfiguratorInputProtocol = TaskListConfigurator()
  private var activityIndicator: UIActivityIndicatorView?
  private let searchController = UISearchController(searchResultsController: nil)
  private var rows: [TaskCellViewModelProtocol] = []
  private var filteredRows: [TaskCellViewModelProtocol] = []
  private var searchBarIsEmpty: Bool {
    guard let text = searchController.searchBar.text else { return false }
    return text.isEmpty
  }
  private var isFiltering: Bool {
    searchController.isActive && !searchBarIsEmpty
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(withView: self)
    activityIndicator = showActivityIndicator(in: view)
    setupSearchController()
    presenter.viewDidLoad()
  }
  
  @IBAction func createTaskButtonPressed() {
    presenter.createTaskButtonPressed()
  }
  
  // MARK: - Private Methods
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
      textField.textColor = .white
    }
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
  
  private func deleteTask(withIndexPath indexPath: IndexPath) {
    let task = rows.remove(at: indexPath.row).task
    tableView.deleteRows(at: [indexPath], with: .automatic)
    presenter.deleteTask(task, indexRow: indexPath.row)
  }
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    isFiltering ? filteredRows.count : rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellViewModel = isFiltering ? filteredRows[indexPath.row] : rows[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
    guard let cell = cell as? TaskCell else { return UITableViewCell() }
    cell.viewModel = cellViewModel
    cell.viewModel?.delegate = self
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
    if isFiltering {
      return nil
    }
    
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { menuElements in
      
      let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { [unowned self] action in
        presenter.editTask(withIndexRow: indexPath.row)
      }
      
      let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { [unowned self] action in
        deleteTask(withIndexPath: indexPath)
      }
      
      let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [editAction, deleteAction])
      
      return menu
    }
    
    return configuration
  }
}

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text ?? "")
  }
  
  private func filterContentForSearchText(_ searchText: String) {
    filteredRows = rows.filter { row in
      guard let titleTask = row.task.todo else { return false }
      return titleTask.lowercased().contains(searchText.lowercased())
    }
    
    tableView.reloadData()
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
  
  func updateTask(for row: TaskCellViewModel, withIndexPath indexPath: IndexPath) {
    rows[indexPath.row] = row
    tableView.reloadRows(at: [indexPath], with: .automatic)
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

// MARK: - TaskCellDelegate
extension TaskListViewController: TaskCellDelegate {
  func checkTask(withTask task: Task, andCell cell: TaskCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    presenter.checkTask(task, indexPath: indexPath)
  }
}

