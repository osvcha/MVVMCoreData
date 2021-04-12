//
//  TasksCellViewModel.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 02/03/2021.
//

import Foundation

class TaskCellViewModel {
    let task: Task
    var textLabelText: String?
    var detailTextLabel: String?
    
    init(task: Task) {
        self.task = task
        textLabelText = task.title
        
        //Date formatting
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"

        detailTextLabel = formatter.string(from: task.createdAt)
    }
}
