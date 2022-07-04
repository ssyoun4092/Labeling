import UIKit
import RxSwift
import RxCocoa

class CategoryViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var onData: AnyObserver<CategoryMenu>

    required init?(coder aDecoder: NSCoder) {
        let data = PublishSubject<CategoryMenu>()
        onData = data.asObserver()

        super.init(coder: aDecoder)

        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] menu in
                self?.mainLabel.text = menu.mainLabel
                self?.iconButton.setImage(UIImage(systemName: menu.iconName), for: .normal)

                switch menu.currentMode {
                case .normal:
                    self?.xButton.isHidden = true
                case .edit:
                    self?.xButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        mainLabel.adjustsFontSizeToFitWidth = true
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
        timerButton.setTitle("", for: .normal)
    }

    //MARK: - IBOutlets
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var numberOfLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!

    @IBAction func tapXButton(_ sender: UIButton) {
//        self.delegate?.removeCategoryCell(cell: self)
    }
}
