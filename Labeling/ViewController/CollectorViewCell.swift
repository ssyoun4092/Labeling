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

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.shadowColor = UIColor.gray.cgColor
        self.contentView.layer.shadowRadius = 10
    }

    func setUpCell() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func showViewColor() {
        print("Tapped!")
        self.cellView.backgroundColor = UIColor.red
    }
}
