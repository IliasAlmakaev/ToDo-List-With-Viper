//
//  TaskCell.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import UIKit

protocol TaskCellModelRepresentable {
  var viewModel: TaskCellViewModelProtocol? { get }
}

class TaskCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var checkButton: UIButton!
  
  var viewModel: TaskCellViewModelProtocol? {
    didSet {
      updateView()
    }
  }
  
  weak var delegate: TaskCellDelegate?
  
  @IBAction func checkButtonPressed() {
    delegate?.checkTask(withTask: viewModel?.task ?? Task(), andCell: self)
  }
  
  private func updateView() {
    guard let viewModel = viewModel as? TaskCellViewModel else { return }
    
    delegate = viewModel.delegate
    
    descriptionLabel.text = viewModel.fullDescription
    dateLabel.text = viewModel.date
    
    checkButton.setImage(
      getImageButton(withCompleted: viewModel.completed),
      for: .normal
    )
    
    setLabelsStyle(withViewModel: viewModel)
  }
  
  private func getImageButton(withCompleted completed: Bool) -> UIImage? {
    let imageNameButton = completed ? "selectedButton" : "unselectedButton"
    return UIImage(named: imageNameButton)
  }
  
  private func setLabelsStyle(withViewModel viewModel: TaskCellViewModel) {
    if viewModel.completed {
      titleLabel.textColor = .white
      descriptionLabel.textColor = .white
      
      titleLabel.attributedText = nil
      titleLabel.text = viewModel.todo
    } else {
      titleLabel.textColor = .lightGray
      descriptionLabel.textColor = .lightGray
      
      titleLabel.attributedText = viewModel.todo.strikeThrough()
    }
  }
}
