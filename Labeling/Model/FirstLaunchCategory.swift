import Foundation

struct FirstLaunchCategory {
    let mainLabel: String
    let doCalendar: Bool
    let doTimer: Bool
    let iconName: String
}

let thinkingLabel = FirstLaunchCategory(mainLabel: "잡생각", doCalendar: false, doTimer: false, iconName: "lightbulb")
let assignmentLabel = FirstLaunchCategory(mainLabel: "과제", doCalendar: false, doTimer: false, iconName: "checklist")
let wantToEatLabel = FirstLaunchCategory(mainLabel: "먹고 싶은 거", doCalendar: false, doTimer: false, iconName: "fork.knife")
let deadlineLabel = FirstLaunchCategory(mainLabel: "마감", doCalendar: true, doTimer: false, iconName: "scroll")
let appointmentLabel = FirstLaunchCategory(mainLabel: "약속", doCalendar: true, doTimer: true, iconName: "calendar")
