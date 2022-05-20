import UIKit

class AddCategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var addButton: UIButton!
    static let identifier = "AddCategoryViewCell"
    var delegate: AddCategoryDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpaddButton()
    }

    func setUpaddButton() {
        addButton.setTitle("", for: .normal)
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        delegate?.showAddCategoryController()
    }
}
