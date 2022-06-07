import UIKit

class NoticeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var items: [NoticeMessage] = NoticeMessage.messages
    typealias Item = NoticeMessage
    enum Section {
        case main
    }
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }

    private func setUpCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.noticeCell, for: indexPath) as? NoticeCell else { return nil }
            cell.configure(item)

            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
        collectionView.collectionViewLayout = layout()
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [itemLayout])

        let section = NSCollectionLayoutSection(group: groupLayout)
        section.interGroupSpacing = 20

        return UICollectionViewCompositionalLayout(section: section)
    }
}
