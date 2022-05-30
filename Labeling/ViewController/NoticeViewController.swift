import UIKit

class NoticeViewController: UIViewController {
    @IBOutlet weak var textView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
        self.title = "공지사항"
    }

    func setUpTextView() {
        self.textView.layer.cornerRadius = 10
    }
}
