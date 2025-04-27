//
//  ScriptRunner.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import Foundation

enum ScriptRunnerError: Error {
    case executionFailed(String)
}

final class ScriptRunner {
    static let shared = ScriptRunner()
    
    private init() { }
    
    @discardableResult
    func runScript(at url: URL) async throws -> String {
        print("running script at \(url.path)")
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [url.path]
        process.currentDirectoryURL = url.deletingLastPathComponent()

        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = outputPipe

        try process.run()
        
        process.waitUntilExit()

        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self)

        print("[Script Output]:\n\(output)")

        if process.terminationStatus != 0 {
            print("[Script Error]: Termination code \(process.terminationStatus)")
            throw ScriptRunnerError.executionFailed(output)
        }

        return output
    }
}
