import UIKit

class OnboardingCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!


    func configure(_ item: OnboardingMessage) {
        self.titleLabel.text = item.title
        self.thumbnailImage.image = UIImage(named: item.imageName)
    }
}
