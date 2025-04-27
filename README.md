# TrayRunner

TrayRunner is a macOS menu bar application that allows you to quickly access and run scripts from your computer. The app sits in your menu bar and provides a fast, keyboard-accessible way to search and execute scripts.

## Features

- **Global Keyboard Shortcut**: Quickly open the script search HUD with ⌘+Shift+Space
- **Script Directory Monitoring**: Add script folders that automatically update when changes are detected
- **TODO: Fuzzy Search**: Type to quickly find and run the script you need
- **Support for Multiple Script Types**: Works with shell (.sh), Python (.py), Ruby (.rb), Perl (.pl), and PHP (.php) scripts // I only tested with .sh so far, might change in the future.

## Requirements

- macOS 15.0 or later // might work with older, I used 15, I don't plan on supporting older
- Xcode 16.0 or later // might work with older, I used 16 tho

## Installation

### Option 1: Download the Release

1. Go to the [Releases](https://github.com/yourusername/TrayRunner/releases) page
2. Download the latest version of TrayRunner.app.zip
3. Extract the ZIP file
4. Move TrayRunner.app to your Applications folder
5. Launch the app

### Build from Source

Just clone the project and Cmd + R in XCode

## Usage

1. After launching TrayRunner, you'll see a terminal icon in your menu bar
2. Click on the menu bar icon to open the menu and access settings
3. Press ⌘+Shift+Space to open the script search overlay
4. Add script folders by opening Settings → Watched Folders
5. Start typing to search for scripts, then press Enter to run the selected script

## Development

### Prerequisites

- Xcode 13.0 or later
- Swift 5.5 or later

### Project Structure

- `TrayRunner/` - Main source code directory
  - `Data/` - Data models and script management
  - `UI/` - User interface components
    - `Components/` - Reusable UI components
    - `Settings/` - Settings interface
    - `Search/` - Script search functionality
  - `Assets.xcassets/` - App assets and icons

### Dependencies

- [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) - For global keyboard shortcut handling

## Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork repo
2. Make PR

## License

This project is licensed under the MIT License - see the LICENSE file for details.
