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
        XCTAssertNil(navigationManager.scrollTarget, "Initial scroll target should be nil")
    }
    
    // MARK: - Navigation Tests
    
    func testMoveDownSuccess() {
        // Test moving down when possible
        let maxIndex = 2
        let didMoveDown = navigationManager.moveDown(maxIndex: maxIndex)
        
        XCTAssertTrue(didMoveDown, "Should be able to move down from index 0")
        XCTAssertEqual(navigationManager.selectedIndex, 1, "Selected index should be 1 after moving down")
        XCTAssertEqual(navigationManager.scrollTarget, 1, "Scroll target should be 1 after moving down")
    }
    
    func testMoveDownAtLimit() {
        // Test moving down when at the bottom limit
        let maxIndex = 2
        navigationManager.selectedIndex = 2  // Set to bottom
        
        let didMoveDown = navigationManager.moveDown(maxIndex: maxIndex)
        
        XCTAssertFalse(didMoveDown, "Should not be able to move down when at bottom limit")
        XCTAssertEqual(navigationManager.selectedIndex, 2, "Selected index should remain 2")
        XCTAssertNil(navigationManager.scrollTarget, "Scroll target should remain nil when move fails")
    }
    
    func testMoveUpSuccess() {
        // First move to index 1, then test moving up
        navigationManager.selectedIndex = 1
        
        let didMoveUp = navigationManager.moveUp()
        
        XCTAssertTrue(didMoveUp, "Should be able to move up from index 1")
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should be 0 after moving up")
        XCTAssertEqual(navigationManager.scrollTarget, 0, "Scroll target should be 0 after moving up")
    }
    
    func testMoveUpAtLimit() {
        // Test moving up when already at the top
        let didMoveUp = navigationManager.moveUp()
        
        XCTAssertFalse(didMoveUp, "Should not be able to move up when at top limit")
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should remain 0")
        XCTAssertNil(navigationManager.scrollTarget, "Scroll target should remain nil when move fails")
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
        navigationManager.scrollTarget = 3
        
        // Reset
        navigationManager.resetForNewSearch()
        
        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should reset to 0")
        XCTAssertEqual(navigationManager.scrollTarget, 0, "Scroll target should be set to 0 for scrolling to top")
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
    
    // MARK: - Scroll Target Management Tests
    
    func testClearScrollTarget() {
        // Set scroll target
        navigationManager.scrollTarget = 5
        XCTAssertEqual(navigationManager.scrollTarget, 5, "Scroll target should be set")
        
        // Clear it
        navigationManager.clearScrollTarget()
        XCTAssertNil(navigationManager.scrollTarget, "Scroll target should be cleared")
    }

//    // MARK: - Edge Case Tests
//    
//    func testNavigationWithEmptyList() {
//        // Test with maxIndex = -1 (empty list)
//        // Todo why -1?
//        let maxIndex = -1
//        
//        let didMoveDown = navigationManager.moveDown(maxIndex: maxIndex)
//        XCTAssertFalse(didMoveDown, "Should not be able to move down in empty list")
//        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should remain 0")
//    }
//    
//    func testNavigationWithSingleItem() {
//        // Test with maxIndex = 0 (single item)
//        let maxIndex = 0
//        
//        let didMoveDown = navigationManager.moveDown(maxIndex: maxIndex)
//        XCTAssertFalse(didMoveDown, "Should not be able to move down in single-item list")
//        XCTAssertEqual(navigationManager.selectedIndex, 0, "Selected index should remain 0")
//    }
//    
//    // MARK: - Integration Tests
//    
//    func testNavigationManagerIntegrationWithView() {
//        // Test that the view correctly exposes the navigation manager
//        XCTAssertNotNil(searchView.testableNavigationManager, "View should expose navigation manager for testing")
//        
//        // Test that operations work through the view's manager
//        let manager = searchView.testableNavigationManager
//        let originalIndex = manager.selectedIndex
//        
//        _ = manager.moveDown(maxIndex: 5)
//        XCTAssertNotEqual(manager.selectedIndex, originalIndex, "Navigation should work through view's manager")
//    }
    
}
