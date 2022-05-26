import Foundation

struct Icons {
    static let calendarSymbol = "calendar"
    static let timerSymbol = "clock"
    static let checkMark = "checkmark.circle"
    static let nonCheckMark = "circle"
}

struct IconPickers {
    let iconPickers: [IconInPicker] = [
        IconInPicker(title: "phone"),
        IconInPicker(title: "trash"),
        IconInPicker(title: "heart"),
        IconInPicker(title: "sum"),
        IconInPicker(title: "video"),
        IconInPicker(title: "pills"),
        IconInPicker(title: "cross"),
        IconInPicker(title: "bed.double"),
        IconInPicker(title: "cart"),
        IconInPicker(title: "bag"),
        IconInPicker(title: "globe"),
        IconInPicker(title: "play"),
        IconInPicker(title: "pause"),
        IconInPicker(title: "stop"),
        IconInPicker(title: "list.bullet"),
        IconInPicker(title: "pencil"),
        IconInPicker(title: "highlighter"),
        IconInPicker(title: "paintbrush"),
        IconInPicker(title: "flame"),
        IconInPicker(title: "leaf"),
        IconInPicker(title: "hands.clap"),
        IconInPicker(title: "person"),
        IconInPicker(title: "airplane"),
        IconInPicker(title: "gamecontroller"),
        IconInPicker(title: "tray.full"),
        IconInPicker(title: "wrench.and.screwdriver"),
        IconInPicker(title: "sun.min")
    ]
}

struct IconInPicker {
    let title: String
}
