import Foundation

struct CategoryMenu {
    let mainLabel: String
    let iconName: String
    let doCalendar: Bool
    let doTimer: Bool

    init(_ item: Category) {
        mainLabel = item.mainLabel ?? ""
        iconName = item.iconName ?? ""
        doCalendar = item.doCalendar
        doTimer = item.doTimer
    }
}
