//
//  ScriptManager.swift
//  TrayRunner
//
//  Created by Yaqin Hasan on 27/04/2025.
//

import Foundation

/// Represents a script file or a folder of scripts
struct ScriptItem: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
    let isFolder: Bool
    var children: [ScriptItem] = []
}

final class ScriptManager: ObservableObject {
    static let shared = ScriptManager()
    
    private var folderWatchers: [DispatchSourceFileSystemObject] = []
    private var watchedFolderFileDescriptors: [CInt] = []
    private(set) var watchedDirectories: [URL] = []
    
    @Published private(set) var rootScripts: [ScriptItem] = []
    
    private init() { }
    
    func addScriptsFolder(_ url: URL) {
        guard !watchedDirectories.contains(url) else { return } // prevent duplicate watches

        watchedDirectories.append(url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let scripts = self.scanDirectory(url)
            DispatchQueue.main.async {
                self.rootScripts += scripts
                self.startWatchingFolder(at: url)
            }
        }
    }
    
    private func startWatchingFolder(at url: URL) {
        let path = (url as NSURL).fileSystemRepresentation
        let fd = open(path, O_EVTONLY)
        
        guard fd != -1 else {
            print("Failed to open directory for watching: \(url.path)")
            return
        }
        
        let watcher = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .rename, .delete],
            queue: DispatchQueue.global(qos: .background)
        )
        
        watcher.setEventHandler { [weak self] in
            guard let self = self else { return }
            print("[Folder Watcher] Change detected in: \(url.lastPathComponent)")
            DispatchQueue.main.async {
                self.loadAllWatchedScripts()
            }
        }
        
        watcher.setCancelHandler {
            close(fd)
        }
        
        watcher.resume()
        
        watchedFolderFileDescriptors.append(fd)
        folderWatchers.append(watcher)
    }
    
    private func stopWatchingFolder() {
        for watcher in folderWatchers {
            watcher.cancel()
        }
        for fd in watchedFolderFileDescriptors {
            if fd != -1 {
                close(fd)
            }
        }
        folderWatchers.removeAll()
        watchedFolderFileDescriptors.removeAll()
        watchedDirectories.removeAll()
    }
    
    func removeScriptsFolder(_ url: URL) {
        if let index = watchedDirectories.firstIndex(of: url) {
            watchedDirectories.remove(at: index)
            let watcher = folderWatchers[index]
            watcher.cancel()
            let fd = watchedFolderFileDescriptors[index]
            if fd != -1 {
                close(fd)
            }
            folderWatchers.remove(at: index)
            watchedFolderFileDescriptors.remove(at: index)
            
            loadAllWatchedScripts() // reload scripts after removing
        }
    }
    
    private func loadAllWatchedScripts() {
        var allScripts: [ScriptItem] = []
        for folder in watchedDirectories {
            let scripts = scanDirectory(folder)
            allScripts.append(contentsOf: scripts)
        }
        rootScripts = allScripts
    }
    
    func scanDirectory(_ url: URL) -> [ScriptItem] {
        var items: [ScriptItem] = []
        
        let fileManager = FileManager.default
        guard let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles]) else {
            return []
        }
        
        for fileURL in contents {
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    let childItems = scanDirectory(fileURL)
                    let folder = ScriptItem(name: fileURL.lastPathComponent, url: fileURL, isFolder: true, children: childItems)
                    items.append(folder)
                } else {
                    if self.isSupportedScript(fileURL) {
                        let script = ScriptItem(name: fileURL.lastPathComponent, url: fileURL, isFolder: false)
                        items.append(script)
                    }
                }
            }
        }
        
        return items.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    private func isSupportedScript(_ url: URL) -> Bool {
        let supportedExtensions = ["sh", "py", "rb", "pl", "php"]
        return supportedExtensions.contains(url.pathExtension.lowercased())
    }
}
