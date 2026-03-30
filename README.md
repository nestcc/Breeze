# DoublePlus

DoublePlus is a macOS utility that adds a **Windows-style “New”** flow to **Finder**: create empty `.txt` and `.md` files and new folders from the context menu, with automatic renaming when a name is taken.

The app stays out of the Dock: it runs as a **menu bar–only agent** (`MenuBarExtra` + `LSUIElement`). Finder menus are provided by a **Finder Sync** extension, which injects a **DoublePlus** submenu. The host app mainly offers hints, opens the system Finder-extensions UI, and quits.

## Features

- **Finder**: Right-click in a window or on a selection → **DoublePlus** → new text, Markdown, or folder.
- **Extensibility**: `FinderContextAction` + `ActionRegistry` in `DoublePlusShared` let you add actions (e.g. future **Share** via `NSSharingService`) without rewriting the extension menu shell.
- **App Group** `group.Ncc.DoublePlus` in entitlements for future shared settings or templates.

## Layout

- `DoublePlus/` — menu bar SwiftUI app  
- `DoublePlusShared/` — actions, registry, file helpers  
- `DoublePlusFinderSync/` — `FIFinderSync` implementation  
- `docs/` — Chinese design and user guides  

## Build

Requires macOS **15.7**+ and Xcode with signing for both the app and embedded `.appex`.

1. Open `DoublePlus.xcodeproj`, choose scheme **DoublePlus** (not the extension alone) and **My Mac**.  
2. **⌘R** to run or **⌘B** to build.

```bash
xcodebuild -scheme DoublePlus -configuration Debug -destination 'platform=macOS' build
```

Enable the Finder extension under **System Settings → Privacy & Security → Extensions → Added Extensions → Finder**. If Xcode shows **“Choose an app to run”**, you picked the extension scheme—use **DoublePlus** as the run target.

The project is a compact reference for **sandboxed** macOS apps that pair a menu bar host with an embedded Finder Sync plug-in and shared Swift sources compiled into both targets. Detailed rationale lives in `docs/` (Chinese).
