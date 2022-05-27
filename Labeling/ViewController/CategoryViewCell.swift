import UIKit

class CategoryViewCell: UICollectionViewCell {
    //MARK: - PROPERTIES
    static let identifier = "CategoryViewCell"

    @IBOutlet weak var iconButton: UIButton!
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
//        self.generateGradient()
//        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
//        self.layer.borderWidth = 1
//        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    func setUpButtons() {
        iconButton.setTitle("", for: .normal)
        xButton.setTitle("", for: .normal)
        calendarButton.setTitle("", for: .normal)
        timerButton.setTitle("", for: .normal)
    }
    @IBAction func tapXButton(_ sender: UIButton) {
        self.delegate?.removeCategoryCell(cell: self)
    }
}
