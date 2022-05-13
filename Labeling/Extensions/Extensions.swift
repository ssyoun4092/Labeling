import Foundation
import UIKit

extension UICollectionViewCell {
    func shake() {

    }
}

extension UITextField {
    func addBottomLineView(width: CGFloat) {
        let bottomView = UIView()
        bottomView.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width + 20, height: width)
        bottomView.backgroundColor = .black
        bottomView.tag = 100
        borderStyle = UITextField.BorderStyle.none
        self.addSubview(bottomView)
    }
}

extension UICollectionView {
    
}
