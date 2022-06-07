import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var xButton: UIButton!
    let messages: [OnboardingMessage] = OnboardingMessage.messages

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        setUpButton()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
        pageControl.numberOfPages = messages.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    func setUpButton() {
        xButton.setTitle("", for: .normal)
    }

    @IBAction func tapXButton(_ sender: UIButton) {
        if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
            guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.categoryViewController) as? CategoryViewController else { return }
            let navVC = UINavigationController(rootViewController: homeVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: false)
        } else {
            dismiss(animated: false)
        }
    }

    deinit {
        print("Deinit OnboardingVC")
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
        cell.configure(messages[indexPath.row])

        return cell
    }

}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return .zero
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / collectionView.bounds.width)
        pageControl.currentPage = index
    }
}
