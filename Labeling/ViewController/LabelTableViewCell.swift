import UIKit

protocol LabelDoneDelegate {
    func changeLabelDoneValue(cell: UITableViewCell)
}

class LabelTableViewCell: UITableViewCell {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var isDoneDelegate: LabelDoneDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.layer.borderWidth = 1.0
//        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10.0
        setUpCheckButton()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    }

    func setUpCheckButton() {
        self.checkButton.setTitle("", for: .normal)
    }

    @IBAction func tapCheckButton(_ sender: UIButton) {
        self.isDoneDelegate?.changeLabelDoneValue(cell: self)
    }
}
