//
//  SettingsWindow.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import SwiftUI

struct SettingsWindow: View {
    @State private var selection: SettingsSection? = .watchedFolders
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: SettingsSection.watchedFolders) {
                    Label("Watched Folders", systemImage: "folder")
                }
            }
            .navigationSplitViewColumnWidth(min: 150, ideal: 180)
        } detail: {
            switch selection {
            case .watchedFolders:
                WatchedFoldersView()
            case .none:
                Text("Select a setting")
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

enum SettingsSection: Hashable {
    case watchedFolders
}
