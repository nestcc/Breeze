# Breeze

Breeze is a macOS utility that adds a **Windows-style “New”** flow to **Finder**: create empty `.txt` and `.md` files and new folders from the context menu, with automatic renaming when a name is taken.

The app stays out of the Dock: it runs as a **menu bar–only agent** (`MenuBarExtra` + `LSUIElement`). Finder menus are provided by a **Finder Sync** extension, which injects a **Breeze** submenu. The host app mainly offers hints, opens the system Finder-extensions UI, and quits.

## Features

- **Finder**: Right-click in a window or on a selection → **Breeze** → new text, Markdown, or folder.
- **Extensibility**: `FinderContextAction` + `ActionRegistry` in `BreezeShared` let you add actions (e.g. future **Share** via `NSSharingService`) without rewriting the extension menu shell.
- **App Group** `group.Ncc.Breeze` in entitlements for future shared settings or templates.

## Layout

- `Breeze/` — menu bar SwiftUI app  
- `BreezeShared/` — actions, registry, file helpers  
- `BreezeFinderSync/` — `FIFinderSync` implementation  
- `docs/` — Chinese design and user guides  

## Build

Requires macOS **15.7**+ and Xcode with signing for both the app and embedded `.appex`.

1. Open `Breeze.xcodeproj`, choose scheme **Breeze** (not the extension alone) and **My Mac**.  
2. **⌘R** to run or **⌘B** to build.

```bash
xcodebuild -scheme Breeze -configuration Debug -destination 'platform=macOS' build
```

Enable the Finder extension under **System Settings → Privacy & Security → Extensions → Added Extensions → Finder**. If Xcode shows **“Choose an app to run”**, you picked the extension scheme—use **Breeze** as the run target.

The project is a compact reference for **sandboxed** macOS apps that pair a menu bar host with an embedded Finder Sync plug-in and shared Swift sources compiled into both targets. Detailed rationale lives in `docs/` (Chinese).
