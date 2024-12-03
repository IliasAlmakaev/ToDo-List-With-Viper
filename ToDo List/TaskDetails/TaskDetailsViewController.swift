//
//  TaskDetailsViewController.swift
//  ToDo List
//
//  Created by Ilyas on 29.11.2024.
//

import UIKit

protocol TaskDetailsViewInputProtocol: AnyObject {
  func setupUI(isCreateTask: Bool, dateText: String, title: String?, description: String?)
}

protocol TaskDetailsViewOutputProtocol {
  init(view: TaskDetailsViewInputProtocol)
  func viewDidLoad()
  func createTask(
    title: String,
    descriptionText: String?,
    creationDate: Date,
    completed: Bool
  )
  func editTask(title: String, descriptionText: String?)
}

final class TaskDetailsViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  var presenter: TaskDetailsViewOutputProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent {
      presenter.editTask(
        title: titleTextField.text ?? "",
        descriptionText: descriptionTextView.text
      )
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
  
  @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    guard let titleText = titleTextField.text else { return }
    
    presenter.createTask(
      title: titleText,
      descriptionText: descriptionTextView.text,
      creationDate: Date(),
      completed: false
    )
  }
  
  private func validateTextField() {
    let textFieldAction = UIAction { [unowned self] _ in
      guard let text = titleTextField.text else { return }
      saveButton.isEnabled = !text.isEmpty
    }
    
    titleTextField.addAction(textFieldAction, for: .editingChanged)
  }
}

// MARK: - TaskDetailsViewInputProtocol
extension TaskDetailsViewController: TaskDetailsViewInputProtocol {
  func setupUI(isCreateTask: Bool, dateText: String, title: String?, description: String?) {
    if isCreateTask {
      saveButton.isEnabled = false
      dateLabel.text = dateText
      validateTextField()
    } else {
      saveButton.setValue(true, forKey: "hidden")
      dateLabel.text = dateText
      titleTextField.text = title
      descriptionTextView.text = description
    }
  }
}
