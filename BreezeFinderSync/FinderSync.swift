import Cocoa
import FinderSync

final class FinderSync: FIFinderSync {

    private struct MenuActionPayload {
        let actionID: String
        let context: FinderActionContext
    }

    private var actionByTag: [Int: MenuActionPayload] = [:]

    override init() {
        super.init()
        let root = URL(fileURLWithPath: "/", isDirectory: true)
        FIFinderSyncController.default().directoryURLs = Set([root])
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        actionByTag.removeAll(keepingCapacity: true)
        let mappedMenuKind = Self.mapMenuKind(menuKind)
        let controller = FIFinderSyncController.default()
        let targeted = controller.targetedURL() as URL?
        let selected = Self.selectedURLs(from: controller)
        let context = FinderActionContext(menuKind: mappedMenuKind, targetedURL: targeted, selectedItemURLs: selected)

        let submenu = NSMenu(title: "Breeze")
        let actions = ActionRegistry.shared.actions(for: mappedMenuKind)
        var nextTag = 1
        for action in actions {
            guard action.validate(context: context) else { continue }
            let item = NSMenuItem(
                title: action.title,
                action: #selector(performMenuAction(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.tag = nextTag
            actionByTag[nextTag] = MenuActionPayload(actionID: action.id, context: context)
            nextTag += 1
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
        guard let payload = actionByTag[sender.tag] else {
            FileCreationService.debugLog("menuClick missingPayload tag=\(sender.tag) title=\(sender.title)")
            return
        }
        FileCreationService.debugLog("menuClick id=\(payload.actionID) kind=\(payload.context.menuKind) targeted=\(payload.context.targetedURL?.path ?? "nil") selectedCount=\(payload.context.selectedItemURLs.count)")
        guard let action = ActionRegistry.shared.action(id: payload.actionID) else { return }
        guard action.validate(context: payload.context) else {
            FileCreationService.debugLog("validate=false id=\(payload.actionID)")
            Self.presentError(FileCreationError.noDirectoryURL)
            return
        }
        do {
            try action.perform(context: payload.context)
            FileCreationService.debugLog("perform=success id=\(payload.actionID)")
        } catch {
            FileCreationService.debugLog("perform=error id=\(payload.actionID) error=\(error.localizedDescription)")
            Self.presentError(error)
        }
    }

    private static func selectedURLs(from controller: FIFinderSyncController) -> [URL] {
        controller.selectedItemURLs() ?? []
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
