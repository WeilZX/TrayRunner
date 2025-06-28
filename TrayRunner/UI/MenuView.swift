//
//  PlaceholderMenuView.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import SwiftUI

struct MenuView: View {
    @State private var settingsWindow: NSWindow?
    
    // Hovering effect variables
    
    enum HoveredMenuItem {
            case settings
            case quit
            case none
        }
        
    @State private var hoveredItem: HoveredMenuItem = .none

    var body: some View {
        VStack (spacing: 1) {
            // Settings Button
            Button("Settings") {
                openSettingsWindow()
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .background(
                hoveredItem == .settings ?
                Color.accentColor.opacity(0.8) : Color.clear
            )
            .contentShape(Rectangle())
            .onHover { isHovered in
                hoveredItem = isHovered ? .settings : .none
            }
            
            
            // Divider
            Divider()
                .background(Color.primary.opacity(0.1))
            
            // Quit Button
            Button("Quit") {
                NSApp.terminate(nil)
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .background(
                hoveredItem == .quit ?
                Color.accentColor.opacity(0.8) : Color.clear
            )
            .contentShape(Rectangle())
            .onHover { isHovered in
                hoveredItem = isHovered ? .quit : .none
            }
        }
        .buttonStyle(.plain)
        .font(.system(size: 13))
        .foregroundColor(.primary)
        .fixedSize(horizontal: true, vertical: false)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
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
