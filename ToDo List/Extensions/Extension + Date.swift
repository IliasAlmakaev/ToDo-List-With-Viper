//
//  Extension + Date.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation

extension Date {
  var formattedDate: String {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "dd/MM/YY"
    
    return format.string(from: self)
  }
}
