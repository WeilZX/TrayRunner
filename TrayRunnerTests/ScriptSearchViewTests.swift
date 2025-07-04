//
//  ScriptSearchViewTests.swift
//  TrayRunnerTests
//
//  Created by admin on 27/06/2025.
//

import Foundation
import XCTest
@testable import TrayRunner

class ScriptSearchViewTests: XCTestCase {
    
    var searchView: ScriptSearchView!
    var navigationManager: ScriptSearchNavigationManager!
    
    override func setUp() {
        super.setUp()
        searchView = ScriptSearchView()
        navigationManager = searchView.testableNavigationManager
    }
    
    override func tearDown() {
        searchView = nil
        navigationManager = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Initial selected index should be 0")
    }
    
    // MARK: - Navigation Tests
    
    func testMoveDownSuccess() {
        // Test moving down when possible
        let maxIndex = 2
        let didMoveDown = navigationManager.moveDown(maxIndex: maxIndex)
        
        XCTAssertTrue(didMoveDown, "Should be able to move down from index 0")
        XCTAssertEqual(navigationManager.selectedIndex, 1, "Selected index should be 1 after moving down")
    }
    
    func testMoveDownAtLimit() {
        // Test moving down when at the bottom limit
        let maxIndex = 2
        navigationManager.selectedIndex = 2  // Set to bottom
        
        let didMoveDown = navigationManager.moveDown(maxIndex: maxIndex)
        
        XCTAssertFalse(didMoveDown, "Should not be able to move down when at bottom limit")
        XCTAssertEqual(navigationManager.selectedIndex, 2, "Selected index should remain 2")
    }
    
    func testMoveUpSuccess() {
        // First move to index 1, then test moving up
        navigationManager.selectedIndex = 1
        
        let didMoveUp = navigationManager.moveUp()
        
        XCTAssertTrue(didMoveUp, "Should be able to move up from index 1")
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should be 0 after moving up")
    }
    
    func testMoveUpAtLimit() {
        // Test moving up when already at the top
        let didMoveUp = navigationManager.moveUp()
        
        XCTAssertFalse(didMoveUp, "Should not be able to move up when at top limit")
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should remain 0")
    }
    
    // MARK: - Navigation Chain Tests
    
    func testNavigationChain() {
        let maxIndex = 3
        
        // Move down multiple times
        XCTAssertTrue(navigationManager.moveDown(maxIndex: maxIndex), "First move down should succeed")
        XCTAssertEqual(navigationManager.selectedIndex, 1)
        
        XCTAssertTrue(navigationManager.moveDown(maxIndex: maxIndex), "Second move down should succeed")
        XCTAssertEqual(navigationManager.selectedIndex, 2)
        
        XCTAssertTrue(navigationManager.moveDown(maxIndex: maxIndex), "Third move down should succeed")
        XCTAssertEqual(navigationManager.selectedIndex, 3)
        
        // Try to move down beyond limit
        XCTAssertFalse(navigationManager.moveDown(maxIndex: maxIndex), "Fourth move down should fail")
        XCTAssertEqual(navigationManager.selectedIndex, 3, "Should stay at limit")
        
        // Move back up
        XCTAssertTrue(navigationManager.moveUp(), "Move up should succeed")
        XCTAssertEqual(navigationManager.selectedIndex, 2)
    }
    
    // MARK: - Reset Functionality Tests
    
    func testResetForNewSearch() {
        // Set navigation to some non-initial state
        navigationManager.selectedIndex = 5
        
        // Reset
        navigationManager.resetForNewSearch()
        
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should reset to 0")
    }
    
    // MARK: - Helper Method Tests
    
    func testCanMoveDownHelper() {
        let maxIndex = 2
        
        // At beginning
        XCTAssertTrue(navigationManager.canMoveDown(maxIndex: maxIndex), "Should be able to move down from start")
        
        // At limit
        navigationManager.selectedIndex = maxIndex
        XCTAssertFalse(navigationManager.canMoveDown(maxIndex: maxIndex), "Should not be able to move down at limit")
    }
    
    func testCanMoveUpHelper() {
        // At beginning
        XCTAssertFalse(navigationManager.canMoveUp(), "Should not be able to move up from start")
        
        // After moving down
        navigationManager.selectedIndex = 1
        XCTAssertTrue(navigationManager.canMoveUp(), "Should be able to move up from index 1")
    }


}
