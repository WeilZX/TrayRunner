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
    @State private var selectedIndex: Int = 0
    // target-based approach for scrolling functionality
    @State private var scrollTarget: Int?
    
    var body: some View {
        VStack {
            TextField("Search Scripts", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .focused($isSearchFieldFocused)
                .onChange(of: searchText) {
                    selectedIndex = 0 // Reset selection to the first item
                    scrollTarget = 0 // Scroll to top when search changes
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
                        .background(index == selectedIndex ? Color.accentColor.opacity(0.3) : Color.clear)
                        .cornerRadius(4)
                        .id(index)
                    }
                    
                    .onKeyPress(.return) {
                        if selectedIndex < filteredScripts.count {
                            Task {
                                _ = try? await ScriptRunner.shared.runScript(at: filteredScripts[selectedIndex].url)
                                ScriptSearchHUD.shared.toggle()
                            }
                        }
                        return .handled
                    }
                    
                    .onChange(of: scrollTarget) {
                        if let target = scrollTarget {
                            scrollTarget = nil
                            // Note: anchor: .top/.center/.bottom can be set up
                            // Smooth scrolling can be implemented up to preference
                            proxy.scrollTo(target)
                        }
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
        .onKeyPress(.upArrow) {
            if selectedIndex > 0 {
                selectedIndex -= 1
                scrollTarget = selectedIndex
            }
            
            return .handled
        }
        .onKeyPress(.downArrow) {
            if selectedIndex < filteredScripts.count - 1{
                selectedIndex += 1
                scrollTarget = selectedIndex
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
        
        // Exit key
        .onKeyPress(.escape) {
            ScriptSearchHUD.shared.toggle()
            return .handled
        }
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
