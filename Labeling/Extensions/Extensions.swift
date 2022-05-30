import Foundation
import UIKit

extension UIViewController {
    func dismissView(byTapping tapView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewObjc))
        tapView.addGestureRecognizer(tapGesture)
    }

    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardObjc))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissViewObjc(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @objc func hideKeyboardObjc(byTapping tapView: UIView) {
        self.view.endEditing(true)
    }
}

extension UITextField {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    func animateTiny() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
    }

    func disappear() {
        self.backgroundColor = Color.cellBackgroundColor
        self.alpha = 0
    }

    func animateAppearAt(initialOrigin: CGPoint) {
        self.frame.origin = initialOrigin
        self.transform = CGAffineTransform.identity
        self.text?.removeAll()
        self.placeholder = "떠오른 생각을 적어주세요"
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.addShadow()
        }
    }
}

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
