//
//  ScriptSearchHUD.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import SwiftUI

final class ScriptSearchHUD {
    static let shared = ScriptSearchHUD()
    
    private var panel: NSPanel?
    
    func toggle() {
        if panel == nil {
            createPanel()
        }
        
        if let panel = panel {
            if panel.isVisible {
                panel.orderOut(nil)
            } else {
                centerPanel(panel)
                panel.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    private func centerPanel(_ panel: NSPanel) {
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let windowWidth = screenRect.width * 0.5
            let windowHeight: CGFloat = 400
            let centeredX = screenRect.midX - windowWidth / 2
            let centeredY = screenRect.midY - windowHeight / 2
            panel.setFrame(NSRect(x: centeredX, y: centeredY, width: windowWidth, height: windowHeight), display: true)
        }
    }
    
    private func createPanel() {
        let contentView = ScriptSearchView()

        let panel = FocusablePanel( // <- use FocusablePanel instead of NSPanel
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.borderless],
            backing: .buffered, defer: true
        )

        panel.isFloatingPanel = true
        panel.level = .floating
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.contentView = NSHostingView(rootView: contentView)

        self.panel = panel
    }
}
