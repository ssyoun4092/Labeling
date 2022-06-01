import UIKit

class CategoryViewCell: UICollectionViewCell {
    //MARK: - PROPERTIES
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var numberOfLabel: UILabel!
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
        self.layer.shadowOffset = CGSize(width: 7, height: 7)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 7, height: 7)).cgPath
        self.layer.masksToBounds = false
    }

    func setUpButtons() {
        iconButton.setTitle("", for: .normal)
        xButton.setTitle("", for: .normal)
        calendarButton.setTitle("", for: .normal)
        calendarButton.setImage(UIImage(systemName: Icons.calendarSymbol), for: .normal)
        timerButton.setTitle("", for: .normal)
        timerButton.setImage(UIImage(systemName: Icons.timerSymbol), for: .normal)
    }
    @IBAction func tapXButton(_ sender: UIButton) {
        self.delegate?.removeCategoryCell(cell: self)
    }
}
