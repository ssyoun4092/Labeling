import UIKit

class CategoryViewCell: UICollectionViewCell {
    //MARK: - PROPERTIES
    static let identifier = "CategoryViewCell"

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    var delegate: CategoryViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
        setUpButtons()
    }

    func setUpCell() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func setUpButtons() {
        xButton.setTitle("", for: .normal)
        calendarButton.setTitle("", for: .normal)
        timerButton.setTitle("", for: .normal)
    }

    @IBAction func tapXButton(_ sender: UIButton) {
        self.delegate?.removeCategoryCell(cell: self)
    }
}
