import UIKit

protocol IconDelegate {
    func changeIconBorderColor(targetCell: UICollectionViewCell)
}

class IconPIckerCell: UICollectionViewCell {
    @IBOutlet weak var iconButton: UIButton!
    var iconDelegate: IconDelegate?
    static let identifier = "IconPIckerCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
        setUpIconButton()
    }

    func setUpCell() {
        self.layer.cornerRadius = 5
    }

    func setUpIconButton() {
        self.iconButton.setTitle("", for: .normal)
        self.iconButton.contentMode = .scaleAspectFit
    }

    @IBAction func tapIconButton(_ sender: UIButton) {
        iconDelegate?.changeIconBorderColor(targetCell: self)
    }
}
