//
//  ScriptSerachNavigationManager.swift
//  TrayRunner
//
//  Created by admin on 26/06/2025.
//

// For every comment that starts with "Question:" It must be addressed then deleted

import Foundation

// Seperating the navigation logic from UI

// What is an observableObject
// What is Published as opposed to private internal or public
class ScriptSearchNavigationManager: ObservableObject {
    @Published var selectedIndex: Int = 0
    @Published var scrollTarget: Int? = nil
    
    func moveDown(maxIndex: Int) -> Bool {
        if selectedIndex < maxIndex {
            selectedIndex += 1
            scrollTarget = selectedIndex  // This will trigger UI update
            return true
        }
        return false
    }
    
    func moveUp() -> Bool {
        if selectedIndex > 0 {
            selectedIndex -= 1
            scrollTarget = selectedIndex  // This will trigger UI update
            return true
        }
        return false
    }
    
    func resetForNewSearch() {
        selectedIndex = 0
        scrollTarget = 0  // This will trigger scroll to top
    }
    
    
    // Helper methods for testing
    func canMoveDown(maxIndex: Int) -> Bool {
        return selectedIndex < maxIndex
    }
    
    func canMoveUp() -> Bool {
        return selectedIndex > 0
    }
    
    // Internal method for tests to set scrollTarget to nil
    internal func clearScrollTarget() {
        scrollTarget = nil
    }
}
