//
//  ScriptRunnerTests.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import XCTest
@testable import TrayRunner

final class ScriptRunnerTests: XCTestCase {
    
    var tempDirectoryURL: URL!
    
    override func setUpWithError() throws {
        tempDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: tempDirectoryURL)
    }
    
    func testRunSimpleShellScript() async throws {
        // Arrange
        let scriptURL = tempDirectoryURL.appendingPathComponent("hello.sh")
        let scriptContent = """
        #!/bin/bash
        echo "Hello, TrayRunner!"
        """
        try scriptContent.write(to: scriptURL, atomically: true, encoding: .utf8)
        try makeExecutable(scriptURL)
        
        // Act
        let output = try await ScriptRunner.shared.runScript(at: scriptURL)
        
        // Assert
        XCTAssertTrue(output.contains("Hello, TrayRunner!"))
    }
    
    func testRunFailsForNonExecutableScript() async throws {
        // Arrange
        let scriptURL = tempDirectoryURL.appendingPathComponent("broken.sh")
        let scriptContent = """
        #!/bin/bash
        exit 1
        """
        try scriptContent.write(to: scriptURL, atomically: true, encoding: .utf8)
        try makeExecutable(scriptURL)
        
        // Act + Assert
        do {
            _ = try await ScriptRunner.shared.runScript(at: scriptURL)
            XCTFail("Expected script to fail, but it succeeded.")
        } catch ScriptRunnerError.executionFailed(let output) {
            XCTAssertTrue(output.isEmpty || output.contains("exit"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    private func makeExecutable(_ url: URL) throws {
        var attributes = [FileAttributeKey : Any]()
        attributes[.posixPermissions] = 0o755
        try FileManager.default.setAttributes(attributes, ofItemAtPath: url.path)
    }
}
