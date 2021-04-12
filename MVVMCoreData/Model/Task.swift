//
//  Task.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 02/03/2021.
//

import Foundation

class Task  {
    let title: String
    let createdAt: Date
    let identifier: String?
    
    init(title: String, createdAt: Date, identifier: String? = nil) {
        self.title = title
        self.createdAt = createdAt
        self.identifier = identifier
    }
    
}
