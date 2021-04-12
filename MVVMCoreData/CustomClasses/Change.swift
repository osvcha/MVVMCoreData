//
//  Change.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 12/03/2021.
//

import Foundation


//TODO: Avoid using Any, change by Generic Type
enum Change {
    case insert(Any, IndexPath)
    case delete(IndexPath)
    case move(IndexPath, IndexPath)
    case update(Any, IndexPath)
}

