//
//  CollectorViewCell.swift
//  Labeling
//
//  Created by MacPro on 2022/04/30.
//

import UIKit

class CollectorViewCell: UICollectionViewCell {

    //MARK: - PROPERTIES
    static let identifier = "collectorCell"

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var cellView: UIView!

//    var clickCount: Int = 0 {
//        didSet {
//            if clickCount == 0 {
//                cellView.backgroundColor = UIColor.lightGray
//            }
//            else {
//                cellView.backgroundColor = UIColor.red
//            }
//        }
//    }
//
//    override var isSelected: Bool {
//        didSet {
//            if !isSelected {
//                cellView.backgroundColor = UIColor.lightGray
//                clickCount = 0
//            }
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }

    func setUpCell() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.gray
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func showViewColor() {
        print("Tapped!")
        self.cellView.backgroundColor = UIColor.red
    }
}
