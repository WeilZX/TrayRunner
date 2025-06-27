////
////  ScriptSearchViewTests.swift
////  TrayRunnerTests
////
////  Created by admin on 27/06/2025.
////
//
//import Foundation
//import XCTest
//@testable import TrayRunner
//
//class ScriptSearchViewTests: XCTestCase {
//    
//    var searchView: ScriptSearchView!
//    
//    override func setUp() {
//        super.setUp()
//        searchView = ScriptSearchView()
//    }
//    
//    override func tearDown() {
////        searchView = nil
//        super.tearDown()
//    }
//    
//    func testInitialState() {
//        XCTAssertEqual(searchView.testableNavigationManager.selectedIndex, 0, "Initial selected index should be 0")
//        XCTAssertNil(searchView.testableNavigationManager.scrollTarget, "Initial scroll target should be nil")
//    }
//    
//    func testNavigationThroughView() {
//        let manager = searchView.testableNavigationManager
//        
//        // Moving down
//        
//        let didMoveDown = manager.moveDown(maxIndex: 2) // moveDown() performs the action but also returns a boolean if the opeartion was successful
//        XCTAssert(didMoveDown, "Should be able to move down from idnex 0")
//        XCTAssertEqual(manager.selectedIndex, 1, "Selected index should be 1 after moving down")
//        XCTAssertEqual(manager.scrollTarget, 1, "Scroll target should be 0 after moving down")
//        
//        
//        // Moving up
//        
//        let didMoveUp = manager.moveUp()
//        XCTAssert(didMoveUp, "Should be ablt to move up from index 1")
//        XCTAssertEqual(manager.selectedIndex, 0, "Selected index should be 0 after moving up")
//        XCTAssertEqual(manager.scrollTarget, 0, "Scroll target should be 0 after moving up")
//        
//    }
//}
