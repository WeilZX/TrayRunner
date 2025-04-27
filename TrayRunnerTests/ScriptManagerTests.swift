//
//  ScriptManagerTests.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import XCTest
@testable import TrayRunner

final class ScriptManagerTests: XCTestCase {
    
    var tempDirectoryURL: URL!
    
    override func setUpWithError() throws {
        tempDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDirectoryURL)
    }
    
    func testScanDirectory_withScripts() throws {
        // Arrange
        let script1 = tempDirectoryURL.appendingPathComponent("script1.sh")
        let script2 = tempDirectoryURL.appendingPathComponent("script2.py")
        let hiddenFile = tempDirectoryURL.appendingPathComponent(".hiddenfile.sh")
        let textFile = tempDirectoryURL.appendingPathComponent("notes.txt")
        
        FileManager.default.createFile(atPath: script1.path, contents: nil)
        FileManager.default.createFile(atPath: script2.path, contents: nil)
        FileManager.default.createFile(atPath: hiddenFile.path, contents: nil)
        FileManager.default.createFile(atPath: textFile.path, contents: nil)
        
        // Act
        let scripts = ScriptManager.shared.scanDirectory(tempDirectoryURL)
        
        // Assert
        XCTAssertEqual(scripts.count, 2)
        XCTAssertTrue(scripts.contains { $0.name == "script1.sh" })
        XCTAssertTrue(scripts.contains { $0.name == "script2.py" })
        XCTAssertFalse(scripts.contains { $0.name == ".hiddenfile.sh" })
        XCTAssertFalse(scripts.contains { $0.name == "notes.txt" })
    }
    
    func testScanDirectory_withSubdirectories() throws {
        // Arrange
        let folder = tempDirectoryURL.appendingPathComponent("SubFolder")
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        
        let script = folder.appendingPathComponent("nested_script.sh")
        FileManager.default.createFile(atPath: script.path, contents: nil)
        
        // Act
        let scripts = ScriptManager.shared.scanDirectory(tempDirectoryURL)
        
        // Assert
        XCTAssertEqual(scripts.count, 1)
        let subfolder = scripts.first
        XCTAssertTrue(subfolder?.isFolder ?? false)
        XCTAssertEqual(subfolder?.children.count, 1)
        XCTAssertEqual(subfolder?.children.first?.name, "nested_script.sh")
    }
}
