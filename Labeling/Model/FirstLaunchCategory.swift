import Foundation

struct FirstLaunchCategory {
    let mainLabel: String
    let doCalendar: Bool
    let doTimer: Bool
    let iconName: String
}

let thinkingLabel = FirstLaunchCategory(mainLabel: "아이디어", doCalendar: false, doTimer: false, iconName: "lightbulb")
let assignmentLabel = FirstLaunchCategory(mainLabel: "할 일", doCalendar: false, doTimer: false, iconName: "checklist")
let wantToEatLabel = FirstLaunchCategory(mainLabel: "먹고 싶은 거", doCalendar: false, doTimer: false, iconName: "fork.knife")
let deadlineLabel = FirstLaunchCategory(mainLabel: "과제", doCalendar: true, doTimer: false, iconName: "scroll")
let appointmentLabel = FirstLaunchCategory(mainLabel: "미팅", doCalendar: true, doTimer: true, iconName: "calendar")
