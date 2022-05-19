import Foundation

struct SettingsSection {
    let header: String
    let cell: [SettingsCell]

    static func createSection() -> [SettingsSection] {
        return [
            SettingsSection(header: "설정", cell: [
                SettingsCell(title: "알림 설정", hasIndicator: true),
                SettingsCell(title: "테마 변경", hasIndicator: true),
                SettingsCell(title: "글씨체 변경", hasIndicator: false)
            ]),
            SettingsSection(header: "지원", cell: [
                SettingsCell(title: "공지 사항", hasIndicator: true),
                SettingsCell(title: "문의 및 의견", hasIndicator: true),
                SettingsCell(title: "앱 평가", hasIndicator: false),
                SettingsCell(title: "이용 방법", hasIndicator: false),
                SettingsCell(title: "버전 정보", hasIndicator: false)
            ]),
            SettingsSection(header: "계정", cell: [
                SettingsCell(title: "계정 정보", hasIndicator: true),
                SettingsCell(title: "로그아웃", hasIndicator: false)
            ])
        ]
    }
}

struct SettingsCell {
    let title: String
    let hasIndicator: Bool
}
