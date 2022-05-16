import Foundation
import UIKit

extension UICollectionViewCell {
    func shake() {

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
        print(UIScreen.main.bounds)
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
}

extension UICollectionView {
    
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
