//
//  MainCellViewModel.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 19/02/2021.
//

import Foundation

class MainCellViewModel {
    let user: User
    var textLabelText: String?
    var detailTextLabel: String?
    
    init(user: User) {
        self.user = user
        textLabelText = user.name
        
        //Formateo de la fecha
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        
        detailTextLabel = formatter.string(from: user.createdAt)
    }
    
}
