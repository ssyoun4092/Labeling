import UIKit

class NoticeCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        print("AwakeFromNib")
        setUpLabel()
    }

    private func setUpLabel() {
        let attrString = NSMutableAttributedString(string: self.descriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.descriptionLabel.attributedText = attrString
    }

    func configure(_ item: NoticeMessage) {
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
        self.dateLabel.text = item.date
    }
}
