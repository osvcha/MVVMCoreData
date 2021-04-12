//
//  User.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 01/03/2021.
//

import Foundation

class User  {
    let name: String
    let createdAt: Date
    let identifier: String?
    
    init(name: String, createdAt: Date, identifier: String? = nil) {
        self.name = name
        self.createdAt = createdAt
        self.identifier = identifier
    }
    
}
