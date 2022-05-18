import Foundation

struct FirstLaunchCategory {
    let mainLabel: String
    let subLabel: String
}

let trashLabel = FirstLaunchCategory(mainLabel: "휴지통", subLabel: "필요없는 생각은 저한테 주세요")
let somedayLabel = FirstLaunchCategory(mainLabel: "언젠가", subLabel: "나중에 찾아볼 것 같을때 저한테 주세요")
let referenceLabel = FirstLaunchCategory(mainLabel: "참고자료", subLabel: "필요할 때 찾아볼 것 같을때 저한테 주세요")
let delegateLabel = FirstLaunchCategory(mainLabel: "위임", subLabel: "다른 누군가에게 맡겨야할 때 저한테 주세요")
let calendarLabel = FirstLaunchCategory(mainLabel: "일정표", subLabel: "특정 시기에 실행해야할 때")
let asapLabel = FirstLaunchCategory(mainLabel: "가능한 빨리", subLabel: "최대한 빨리 해야할 때")

