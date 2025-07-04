//
//  main.swift
//  TrayRunner
//
//  Created by admin on 30/06/2025.
//

import AppKit

let app = NSApplication.shared
let delegate = TrayRunnerMenu()
app.delegate = delegate

// Set app to accessory mode (menu bar only, no dock icon)
app.setActivationPolicy(.accessory)

// Start the application
app.run()
