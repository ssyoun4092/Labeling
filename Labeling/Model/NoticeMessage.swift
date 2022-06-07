import Foundation

struct NoticeMessage: Hashable {
    let title: String
    let description: String
    let date: String
}

extension NoticeMessage {
    static let messages: [NoticeMessage] = [
        NoticeMessage(title: "1.1.0 업데이트", description: "헷 처음으로 업데이트 해보네요!\n처음 앱을 실행했을 때, 앱 사용방법이 보이는 화면이 추가됐습니다. 또한 메모를 작성하고 가만히 있을 경우, 메모가 위아래로 살랑살랑 흔들리는 애니메이션 추가했습니다!", date: "22/06/08"),
        NoticeMessage(title: "첫번째 공지사항", description: "안녕하세요! <라벨링>입니다.\n처음으로 개발한 어플이라 많이 미흡합니다. 부족한 점들은 차근차근 개선해 나가며 발전하는 <라벨링>이 되겠습니다.", date: "22/06/05"),
    ]
}
