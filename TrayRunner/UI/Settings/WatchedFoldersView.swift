//
//  WatchedFoldersView.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import SwiftUI

struct WatchedFoldersView: View {
    @ObservedObject private var scriptManager = ScriptManager.shared
    @State private var selectedFolders: Set<URL> = []
    
    var body: some View {
        VStack {
            List(selection: $selectedFolders) {
                ForEach(scriptManager.watchedDirectories, id: \.self) { folderURL in
                    Text(folderURL.lastPathComponent)
                        .font(.system(size: 13, weight: .regular))
                        .help(folderURL.path) // Hover shows full path
                }
            }
            .listStyle(.inset)
            .frame(minHeight: 300)
            
            HStack {
                Button(action: addFolder) {
                    Image(systemName: "plus")
                }
                Button(action: removeSelectedFolders) {
                    Image(systemName: "minus")
                }
                .disabled(selectedFolders.isEmpty)
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
    }
    
    private func addFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = "Select"
        
        if panel.runModal() == .OK {
            for url in panel.urls {
                scriptManager.addScriptsFolder(url)
            }
        }
    }
    
    private func removeSelectedFolders() {
        for folder in selectedFolders {
            scriptManager.removeScriptsFolder(folder)
        }
        selectedFolders.removeAll()
    }
}
