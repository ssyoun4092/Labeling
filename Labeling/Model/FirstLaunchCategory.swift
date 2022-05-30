import Foundation

struct FirstLaunchCategory {
    let mainLabel: String
    let doCalendar: Bool
    let doTimer: Bool
    let iconName: String
}

let trashLabel = FirstLaunchCategory(mainLabel: "잡생각", doCalendar: false, doTimer: false, iconName: "lightbulb")
let somedayLabel = FirstLaunchCategory(mainLabel: "과제", doCalendar: false, doTimer: false, iconName: "checklist")
let delegateLabel = FirstLaunchCategory(mainLabel: "먹고 싶은 거", doCalendar: false, doTimer: false, iconName: "fork.knife")
let calendarLabel = FirstLaunchCategory(mainLabel: "마감", doCalendar: true, doTimer: false, iconName: "scroll")
let asapLabel = FirstLaunchCategory(mainLabel: "약속", doCalendar: true, doTimer: true, iconName: "calendar")
