//
//  ScriptSearchView.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import SwiftUI

struct ScriptSearchView: View {
    @ObservedObject private var scriptManager = ScriptManager.shared
    @State private var searchText: String = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    @StateObject private var navigationManager = ScriptSearchNavigationManager()
    
    // For Unit testing purposes
    internal var testableNavigationManager: ScriptSearchNavigationManager {
        return navigationManager
    }
    
    var body: some View {
        VStack {
            TextField("Search Scripts", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .focused($isSearchFieldFocused)
                .onChange(of: searchText) {
                    Task { @MainActor in
                        navigationManager.resetForNewSearch()
                    }
                }
                .onAppear {
                    Task { @MainActor in
                        isSearchFieldFocused = true
                    }
                }
            
            if !filteredScripts.isEmpty {
                
                // Gives each script a number/index
                ScrollViewReader { proxy in
                    List(Array(filteredScripts.enumerated()), id: \.offset) { index, script in
                        Button(action: {
                            Task {
                                _ = try? await ScriptRunner.shared.runScript(at: script.url)
                                ScriptSearchHUD.shared.toggle()
                            }
                        }) {
                            Text(script.name)
                        }
                        
                        // Inside list - only item styling
                        .buttonStyle(.plain)
                        .background(index == navigationManager.selectedIndex ? Color.accentColor.opacity(0.3) : Color.clear)
                        .cornerRadius(4)
                        .id(index)
                    }
                }
            }
        }
        
        // Outside VStack - whole window styling
        .frame(width: 600, height: 400)
        .background(VisualEffectBlur()) // Adds nice macOS blur
        .cornerRadius(12)
        .padding()
        
        // Keyboard navigation controls
        
        // Move up
        .onKeyPress(.upArrow) {
            Task { @MainActor in
                navigationManager.moveUp()
            }
            return .handled
        }
        
        // Move down
        .onKeyPress(.downArrow) {
            Task { @MainActor in
                navigationManager.moveDown(maxIndex: filteredScripts.count - 1)
            }
            return .handled
        }
        
        // Enter key handler moved to VStack level to catch keypress regardless of focus
        // (TextField has focus, but VStack can still intercept Enter key events)
        // Execute Script
        .onKeyPress(.return) {
            // Focus on the list here
            if navigationManager.selectedIndex < filteredScripts.count {
                Task {
                    _ = try? await ScriptRunner.shared.runScript(at: filteredScripts[navigationManager.selectedIndex].url)
                    ScriptSearchHUD.shared.toggle()
                    // I would be wary of this
                    clearSearchText()
                }
            }
            return .handled
        }
        
        // GLOBAL KEY HANDLING: Any other key refocuses search
        .onKeyPress { keyPress in
            // Arrow keys and return are handled above, so this catches everything else
            if keyPress.key != .upArrow && keyPress.key != .downArrow && keyPress.key != .return && keyPress.key != .escape {
                isSearchFieldFocused = true
                // The typed character will automatically appear in the search field
                return .ignored  // Let the system handle the character input
            }
            return .ignored
        }
        
        // Exit key and Reset search
        .onKeyPress(.escape) {
            ScriptSearchHUD.shared.toggle()
            // Triggers onChange which calls resetForNewSearch
            clearSearchText()
            return .handled
        }
    }
    
    private func clearSearchText() {
        
        searchText = ""
    }
    
    private var filteredScripts: [ScriptItem] {
        if searchText.isEmpty {
            return []
        } else {
            return scriptManager.rootScripts
                .flatMap { flattenScripts($0) }
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func flattenScripts(_ item: ScriptItem) -> [ScriptItem] {
        if item.isFolder {
            return item.children.flatMap { flattenScripts($0) }
        } else {
            return [item]
        }
    }
}
