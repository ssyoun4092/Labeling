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
    func addBottomLineView(width: CGFloat, height: CGFloat) {
        let bottomView = UIView()
        bottomView.frame = CGRect(x: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width * 0.05) - (width / 2), y: self.frame.size.height - height, width: width, height: height)
        bottomView.backgroundColor = .black
        bottomView.tag = 100
        borderStyle = UITextField.BorderStyle.none
        self.addSubview(bottomView)
    }

    func animateDisappearAndAppearAt(initialOrigin: CGPoint, duration: TimeInterval, bottomLineAction: ()) {
        self.alpha = 0
        self.frame.origin = initialOrigin
        self.transform = CGAffineTransform.identity
        self.text?.removeAll()
        UIView.animate(withDuration: duration) {
            self.alpha = 1
            bottomLineAction
        }
    }

    func addShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    func showShadow() {
        self.layer.shadowOpacity = 0.5
    }

    func hideShadow() {
        self.layer.shadowOpacity = 0
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

extension UIView {
    func generateGradient() {
        let colors: [CGColor] = [
            .init(red: 9/255, green: 198/255, blue: 249/255, alpha: 1),
            .init(red: 4/255, green: 93/255, blue: 233/255, alpha: 1)
        ]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [1.0, 0.0]
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func disableGradient() {
        if let layers = self.layer.sublayers {
            layers[0].removeFromSuperlayer()
        }
    }
}
