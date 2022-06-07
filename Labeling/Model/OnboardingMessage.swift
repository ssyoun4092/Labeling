import Foundation

struct OnboardingMessage {
    let title: String
    let imageName: String
}

extension OnboardingMessage {
    static let messages: [OnboardingMessage] = [
        OnboardingMessage(title: "홈화면에서 메모를 작성할 수 있고,\n카테고리를 확인할 수 있어요", imageName: "Onboarding1"),
        OnboardingMessage(title: "메모를 저장하실 때는\n드래그&드롭으로 하실 수 있어요", imageName: "Onboarding2"),
        OnboardingMessage(title: "저장된 메모는 카테고리를\n 클릭하시면 볼 수 있어요", imageName: "Onboarding3"),
        OnboardingMessage(title: "원하는 카테고리룰\n추가하실 수 있어요", imageName: "Onboarding4")
    ]
}
