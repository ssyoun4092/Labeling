import UIKit

class AddCategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var addButton: UIButton!
    var delegate: AddSelectedDateTimeDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpaddButton()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddCell)))
    }

    @objc func tapAddCell() {
        delegate?.presentAddCategoryController()
    }

    func setUpCell() {
        self.layer.cornerRadius = 10
        self.backgroundColor = Color.cellBackgroundColor
        self.isUserInteractionEnabled = false
//        self.generateGradient()
//        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        self.layer.borderWidth = 1
//        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func setUpaddButton() {
        addButton.setTitle("", for: .normal)
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        delegate?.presentAddCategoryController()
    }
}
