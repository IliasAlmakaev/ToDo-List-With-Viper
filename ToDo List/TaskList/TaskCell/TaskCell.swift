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
  
  var viewModel: TaskCellViewModelProtocol? {
    didSet {
      updateView()
    }
  }
  
  @IBOutlet weak var checkButton: UIButton!
  
  @IBAction func checkButtonPressed() {
  }
  
  private func updateView() {
    guard let viewModel = viewModel as? TaskCellViewModel else { return }
    
    titleLabel.text = viewModel.todo
    descriptionLabel.text = viewModel.fullDescription
    dateLabel.text = viewModel.date
    
    checkButton.setImage(
      getImageButton(withCompleted: viewModel.completed),
      for: .normal
    )
  }
  
  private func getImageButton(withCompleted completed: Bool) -> UIImage? {
    let imageNameButton = completed ? "selectedButton" : "unselectedButton"
    return UIImage(named: imageNameButton)
  }
}
