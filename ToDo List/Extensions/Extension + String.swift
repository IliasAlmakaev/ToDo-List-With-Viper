//
//  Extension + String.swift
//  ToDo List
//
//  Created by Ilyas on 03.12.2024.
//

import Foundation
import UIKit

extension String {
  func strikeThrough() -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: self)
    attributedString.addAttributes([
      .strikethroughStyle: NSUnderlineStyle.single.rawValue,
      .strikethroughColor: UIColor.lightGray
    ], range: NSMakeRange(0, attributedString.length)
    )
    return attributedString
  }
}
