import UIKit

class AddCategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var addButton: UIButton!
    static let identifier = "AddCategoryViewCell"
    var delegate: AddCategoryDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpaddButton()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddCell)))
    }

    @objc func tapAddCell() {
        delegate?.showAddCategoryController()
    }

    func setUpaddButton() {
        addButton.setTitle("", for: .normal)
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        delegate?.showAddCategoryController()
    }
}
