import UIKit

class LabelTableViewController: UITableViewController {
    var selectedCategory: Category? {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct LabeledTableViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LabelTableViewController

    func makeUIViewController(context: Context) -> LabelTableViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabeledTableViewController") as! LabelTableViewController
    }

    func updateUIViewController(_ uiViewController: LabelTableViewController, context: Context) {

    }
}

struct LabeledTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        LabeledTableViewControllerRepresentable()
            .preferredColorScheme(.light)
    }
}
#endif
