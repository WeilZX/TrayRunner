//
//  PlaceholderMenuView.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import SwiftUI

struct MenuView: View {
    @State private var settingsWindow: NSWindow?
    
    var body: some View {
        VStack {
            Button("Settings") {
                openSettingsWindow()
            }
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
    }
    
    private func openSettingsWindow() {
        if settingsWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered, defer: false
            )
            window.center()
            window.title = "TrayRunner Settings"
            window.isReleasedWhenClosed = false
            window.contentView = NSHostingView(rootView: SettingsWindow())
            self.settingsWindow = window
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
