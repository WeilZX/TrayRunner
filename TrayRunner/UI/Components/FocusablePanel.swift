//
//  FocusablePanel.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import AppKit

final class FocusablePanel: NSPanel {
    override var canBecomeKey: Bool {
        true
    }
    
    override var canBecomeMain: Bool {
        true
    }
}
