import UIKit

class IconPickerViewConroller: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var passIconDelegate: PassingIconDelegate?
    let icons = IconPickers()
    var highlightedCellIndexPath: IndexPath? {
        didSet {
            self.doneButton.tintColor = Color.accentColor
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        setUpCollectionView()
        setUpButtons()
    }

    private func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.register(UINib(nibName: "IconPickerCell", bundle: nil), forCellWithReuseIdentifier: Identifier.iconPIckerCell)
    }

    private func setUpCollectionView() {
        self.collectionView.layer.cornerRadius = 10
        self.iconView.layer.cornerRadius = 10
    }

    private func setUpButtons() {
        self.cancelButton.tintColor = Color.mainTextColor
        self.doneButton.tintColor = .systemGray3
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.passIconDelegate?.passSelectedIcon(name: "Pick Icon!")
        print("tap Cancel Button")
        self.dismiss(animated: true)
    }

    @IBAction func tapDoneButton(_ sender: UIButton) {
        if !(self.doneButton.tintColor == .systemGray3) {
            guard let targetIndexPath = self.highlightedCellIndexPath else { return }
            var selectedIconName = ""
            if targetIndexPath.row != 0 {
                selectedIconName = self.icons.iconPickers[(targetIndexPath.row - 1)].title
                print(selectedIconName)
            }
            self.passIconDelegate?.passSelectedIcon(name: selectedIconName)
            self.dismiss(animated: true)
        }
    }

    deinit {
        print("IconPicker Deinit")
    }
}

extension IconPickerViewConroller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return (icons.iconPickers.count + 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.iconPIckerCell, for: indexPath) as! IconPIckerCell
        if indexPath.row == 0 {
            iconCell.iconButton.setImage(UIImage(), for: .normal)
            iconCell.layer.borderWidth = 0
        } else {
            iconCell.iconButton.setImage(UIImage(systemName: "\(icons.iconPickers[indexPath.row - 1].title)"), for: .normal)
            iconCell.layer.borderWidth = 0
        }
        if let highlightedIndexPath = self.highlightedCellIndexPath {
            if indexPath == highlightedIndexPath {
                iconCell.layer.borderWidth = 1.0
                iconCell.layer.borderColor = Color.accentColor?.cgColor
            }
        }
        iconCell.iconDelegate = self

        return iconCell
    }
}

extension IconPickerViewConroller: IconDelegate {
    func changeIconBorderColor(targetCell: UICollectionViewCell) {
        guard let cell = targetCell as? IconPIckerCell else { return }
        let cellIndexPath = collectionView.indexPath(for: cell)
        self.highlightedCellIndexPath = cellIndexPath
    }
}

extension IconPickerViewConroller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interSpacingCell: CGFloat = 10
        let cellWidth = (collectionView.bounds.width - ((interSpacingCell * 2) + 1)) / 3
        let cellHeight = cellWidth

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return CGFloat(10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return CGFloat(10)
    }
}
