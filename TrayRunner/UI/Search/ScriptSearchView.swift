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
    
    var body: some View {
        VStack {
            TextField("Search Scripts", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .focused($isSearchFieldFocused)
            // When user types something new, it reset selcetion to the first item
                .onChange(of: searchText) { _, _ in
                    selectedIndex = 0
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.isSearchFieldFocused = true
                    }
                }
            
            if !filteredScripts.isEmpty {
                // Gives each script a number/index
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
            }
            return .handled
        }
        .onKeyPress(.downArrow) {
            if selectedIndex < filteredScripts.count - 1 {
                selectedIndex += 1
            }
            return .handled
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

