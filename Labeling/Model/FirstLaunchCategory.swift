import Foundation

struct FirstLaunchCategory {
    let mainLabel: String
    let subLabel: String
    let doCalendar: Bool
    let doTimer: Bool
    let iconName: String
}

let trashLabel = FirstLaunchCategory(mainLabel: "휴지통", subLabel: "ex) 저녁 닭갈비 먹어야지!", doCalendar: false, doTimer: false, iconName: "trash")
let somedayLabel = FirstLaunchCategory(mainLabel: "언젠가", subLabel: "ex) 신박한 아이디어", doCalendar: false, doTimer: false, iconName: "pencil")
let delegateLabel = FirstLaunchCategory(mainLabel: "위임", subLabel: "ex) 9시까지 설거지 좀 부탁해", doCalendar: false, doTimer: false, iconName: "paperplane")
let calendarLabel = FirstLaunchCategory(mainLabel: "일정표", subLabel: "ex) 이번주 친구 생파!", doCalendar: true, doTimer: false, iconName: "list.dash")
let asapLabel = FirstLaunchCategory(mainLabel: "가능한 빨리", subLabel: "ex) 과제...", doCalendar: true, doTimer: true, iconName: "doc")


