import Foundation

struct CategoryMenu {
    let mainLabel: String
    let iconName: String
    let doCalendar: Bool
    let doTimer: Bool

    let currentMode: EditMode

    init(_ item: Category, mode: EditMode) {
        mainLabel = item.mainLabel ?? ""
        iconName = item.iconName ?? ""
        doCalendar = item.doCalendar
        doTimer = item.doTimer
        currentMode = mode
    }
}

enum EditMode {
    case normal
    case edit
}
