import UIKit

class OnboardingCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ item: OnboardingMessage) {
        self.titleLabel.text = item.title
        self.thumbnailImage.image = UIImage(named: item.imageName)
    }
}
