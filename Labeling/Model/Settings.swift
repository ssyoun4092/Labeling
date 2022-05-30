import Foundation

struct SettingsSection {
    let header: String
    let cell: [SettingsCell]

    static func createSection() -> [SettingsSection] {
        return [
            SettingsSection(header: "설정", cell: [
                SettingsCell(title: "공지사항", hasIndicator: true),
                SettingsCell(title: "테마 변경", hasIndicator: true),
            ]),
            SettingsSection(header: "피드백", cell: [
                SettingsCell(title: "DM 보내기", hasIndicator: false)
            ])
        ]
    }
}

struct SettingsCell {
    let title: String
    let hasIndicator: Bool
}
