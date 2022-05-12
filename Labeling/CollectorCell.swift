//
//  CollectorCell.swift
//  Labeling
//
//  Created by MacPro on 2022/04/30.
//

import UIKit

class CollectorCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

//        self.isUserInteractionEnabled = true
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
//        self.addGestureRecognizer(gesture)

    }
//
//    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
//        let transition = gesture.translation(in: self)
//        let label = gesture.view!
//
//        label.center = CGPoint(x: label.center.x + transition.x, y: label.center.y + transition.y)
//        gesture.setTranslation(.zero, in: self)
//    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

}
