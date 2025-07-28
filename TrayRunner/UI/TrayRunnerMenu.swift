//
//  AppDelegate.swift
//  TrayRunner
//
//  Created by Weil on 30/06/2025.
//

import AppKit
import SwiftUI
import KeyboardShortcuts

class TrayRunnerMenu: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var settingsWindow: NSWindow?
    
    private var scriptManager = ScriptManager.shared
    
    func onLaunchFinish(_ notification: Notification) {
        
        // Setup keyboard shortcuts
        setupKeyboardShortcuts()
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Configure the status bar button with terminal icon
        if let button = statusItem?.button {
            // Use your original terminal icon
            button.image = NSImage(systemSymbolName: "terminal", accessibilityDescription: "TrayRunner Scripts")
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }
        
        // Assign the menu
        statusItem?.menu = createMenu()
    }
    
    @objc private func statusBarButtonClicked() {
        // Empty - menu shows automatically
    }
    
    private func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        // Settings menu item
        let settingsItem = NSMenuItem(
            title: "Settings",
            action: #selector(openSettingsWindow),
            keyEquivalent: ""
        )
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        // Separator
        menu.addItem(NSMenuItem.separator())
        
        // Quit menu item
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)
        
        return menu
    }
    
    @objc private func openSettingsWindow() {
        if settingsWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )
            window.center()
            window.title = "TrayRunner Settings"
            window.isReleasedWhenClosed = false
            window.contentView = NSHostingView(rootView: SettingsWindow())
            settingsWindow = window
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    private func setupKeyboardShortcuts() {
        KeyboardShortcuts.onKeyUp(for: .showScriptSearch) {
            ScriptSearchHUD.shared.toggle()
        }
        
        if KeyboardShortcuts.getShortcut(for: .showScriptSearch) == nil {
            KeyboardShortcuts.setShortcut(
                KeyboardShortcuts.Shortcut(.space, modifiers: [.command, .shift]),
                for: .showScriptSearch
            )
        }
    }
}
