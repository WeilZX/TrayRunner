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
    
    var body: some View {
        VStack {
            TextField("Search Scripts", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .focused($isSearchFieldFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.isSearchFieldFocused = true
                    }
                }
            
            if !filteredScripts.isEmpty {
                List(filteredScripts) { script in
                    Button(action: {
                        Task {
                            // intentional discard, we don't need the result
                            _ = try? await ScriptRunner.shared.runScript(at: script.url)
                            ScriptSearchHUD.shared.toggle()
                        }
                    }) {
                        Text(script.name)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(width: 600, height: 400)
        .background(VisualEffectBlur()) // Adds nice macOS blur
        .cornerRadius(12)
        .padding()
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
