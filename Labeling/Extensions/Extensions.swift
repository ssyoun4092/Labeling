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

    func animateAppear(at point: CGPoint) {
        self.frame.origin = point
        self.transform = CGAffineTransform.identity
        self.text?.removeAll()
        self.placeholder = "떠오른 생각을 적어주세요"
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.addShadow()
        }
    }

    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.25
        shakeAnimation.repeatCount = 3
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
    }

    func stopShake() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
    }
}

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(false, forKey: "isFirstLaunch")

            return true
        }

        return false
    }
}
