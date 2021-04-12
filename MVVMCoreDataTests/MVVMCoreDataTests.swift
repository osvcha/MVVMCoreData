//
//  MVVMCoreDataTests.swift
//  MVVMCoreDataTests
//
//  Created by Osvaldo Chaparro on 08/04/2021.
//

import XCTest
@testable import MVVMCoreData

class DoubleMainDataManager: MainDataManager {
    func startListeningChangesOnUsers(objectChanged: @escaping ChangeClosure) {
        
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        
    }
    
    func deleteAllObjects() {
        
    }
    
    func deleteUser(at: IndexPath) {
        
    }
    
    func createDummyContent() {
        
    }
    
    
}

class MainViewModelTests: XCTestCase {

    
        
    var sut: MainViewModel!
    var doubleDataManager: MainDataManager! = DoubleMainDataManager()
    
    override func setUp() {
        super.setUp()
        sut = MainViewModel(dataManager: doubleDataManager)
    }
    
    override func tearDown() {
        sut = nil
        doubleDataManager = nil
        super.tearDown()
    }
    
    func testGivenAViewModelTheNumberOfSectionShouldBeOne() {
        let expectedSections = 1
        let numberOfSections = sut.numberOfSections()
        
        XCTAssertEqual(numberOfSections, expectedSections)
        
    }
    
    func testGivenViewModelTheNumberOfRowsShouldBeEmpty() {
        let numberOfRows = sut.numberOfRows(in: 0)
        
        XCTAssertEqual(numberOfRows, 0)
    }
    
}
