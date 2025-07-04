//
//  ScriptSerachNavigationManager.swift
//  TrayRunner
//
//  Created by admin on 26/06/2025.
//

import Foundation

// Seperating the navigation logic from UI

class ScriptSearchNavigationManager: ObservableObject {
    @Published var selectedIndex: Int = 0
    
    func moveDown(maxIndex: Int) -> Bool {
        if selectedIndex < maxIndex {
            selectedIndex += 1
            return true
        }
        return false
    }
    
    func moveUp() -> Bool {
        if selectedIndex > 0 {
            selectedIndex -= 1
            return true
        }
        return false
    }
    
    func resetForNewSearch() {
        selectedIndex = 0
    }
    
    
    // Helper methods for testing
    func canMoveDown(maxIndex: Int) -> Bool {
        return selectedIndex < maxIndex
    }
    
    func canMoveUp() -> Bool {
        return selectedIndex > 0
    }
    
}
