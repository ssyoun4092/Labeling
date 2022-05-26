import UIKit

protocol PassingIconDelegate {
    func passSelectedIcon(name: String)
}

class IconPickerViewConroller: UIViewController {
    static let idenfier = "IconPickerViewConroller"
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var passIconDelegate: PassingIconDelegate?
    let icons = IconPickers()
    var highlightedCellIndexPath: IndexPath? {
        didSet {
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
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let cellWidth = (((UIScreen.main.bounds.width - 40) - 20) / 3)
        print("ScreenBounds: \(UIScreen.main.bounds.width)")
        print("CollectionViewBounds: \(collectionView.bounds.width)")
        let cellWidth = ((collectionView.bounds.width - 20) / 3)
        let cellHeight = cellWidth
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.collectionViewLayout = flowLayout
        self.collectionView.allowsSelection = true
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.register(UINib(nibName: "IconPickerCell", bundle: nil), forCellWithReuseIdentifier: IconPIckerCell.identifier)
    }

    private func setUpCollectionView() {
        self.collectionView.layer.cornerRadius = 10
        self.iconView.layer.cornerRadius = 10
    }

    private func setUpButtons() {
        self.cancelButton.tintColor = Color.textColor
        self.doneButton.tintColor = .systemGray3
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
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
}

extension IconPickerViewConroller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return (icons.iconPickers.count + 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: IconPIckerCell.identifier, for: indexPath) as! IconPIckerCell
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

extension IconPickerViewConroller: UICollectionViewDelegate {

}

extension IconPickerViewConroller: IconDelegate {
    func changeIconBorderColor(targetCell: UICollectionViewCell) {
        guard let cell = targetCell as? IconPIckerCell else { return }
        let cellIndexPath = collectionView.indexPath(for: cell)
        self.highlightedCellIndexPath = cellIndexPath
        self.doneButton.tintColor = Color.accentColor
    }
}