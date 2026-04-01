import Cocoa
import FinderSync

final class FinderSync: FIFinderSync {

    /// Valid only during menu construction and menu item handling (per Apple docs for targeted/selected URLs).
    private var lastMenuKind: FinderMenuKind = .contextualMenuForContainer

    override init() {
        super.init()
        let root = URL(fileURLWithPath: "/", isDirectory: true)
        FIFinderSyncController.default().directoryURLs = Set([root])
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        lastMenuKind = Self.mapMenuKind(menuKind)
        let controller = FIFinderSyncController.default()
        let targeted = controller.targetedURL() as URL?
        let selected = Self.selectedURLs(from: controller)

        let submenu = NSMenu(title: "Breeze")
        let actions = ActionRegistry.shared.actions(for: lastMenuKind)
        for action in actions {
            let ctx = FinderActionContext(menuKind: lastMenuKind, targetedURL: targeted, selectedItemURLs: selected)
            guard action.validate(context: ctx) else { continue }
            let item = NSMenuItem(
                title: action.title,
                action: #selector(performMenuAction(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.representedObject = action.id
            submenu.addItem(item)
        }

        guard !submenu.items.isEmpty else { return nil }

        let rootMenu = NSMenu()
        let parent = NSMenuItem(title: "Breeze", action: nil, keyEquivalent: "")
        parent.submenu = submenu
        rootMenu.addItem(parent)
        return rootMenu
    }

    @objc private func performMenuAction(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        let controller = FIFinderSyncController.default()
        let targeted = controller.targetedURL() as URL?
        let selected = Self.selectedURLs(from: controller)
        let ctx = FinderActionContext(menuKind: lastMenuKind, targetedURL: targeted, selectedItemURLs: selected)
        guard let action = ActionRegistry.shared.action(id: id) else { return }
        guard action.validate(context: ctx) else { return }
        do {
            try action.perform(context: ctx)
        } catch {
            Self.presentError(error)
        }
    }

    private static func selectedURLs(from controller: FIFinderSyncController) -> [URL] {
        guard let urls = controller.selectedItemURLs() as? [URL] else { return [] }
        return urls
    }

    private static func mapMenuKind(_ kind: FIMenuKind) -> FinderMenuKind {
        switch kind {
        case .contextualMenuForItems:
            return .contextualMenuForItems
        case .contextualMenuForContainer:
            return .contextualMenuForContainer
        case .contextualMenuForSidebar:
            return .contextualMenuForSidebar
        case .toolbarItemMenu:
            return .toolbarItemMenu
        @unknown default:
            return .toolbarItemMenu
        }
    }

    private static func presentError(_ error: Error) {
        let alert = NSAlert()
        alert.messageText = "Breeze"
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .warning
        alert.runModal()
    }
}
