import SwiftUI
import KeyboardShortcuts

@main
struct TrayRunnerApp: App {
    @StateObject private var scriptManager = ScriptManager.shared

    var body: some Scene {
        MenuBarExtra("Scripts", systemImage: "terminal") {
            MenuView()
                .onAppear {
                    setupKeyboardShortcuts()
                }
        }
        .menuBarExtraStyle(.window)
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
