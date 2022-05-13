import UIKit

class LabeledTableViewController: UITableViewController {

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
    typealias UIViewControllerType = LabeledTableViewController

    func makeUIViewController(context: Context) -> LabeledTableViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabeledTableViewController") as! LabeledTableViewController
    }

    func updateUIViewController(_ uiViewController: LabeledTableViewController, context: Context) {

    }
}

struct LabeledTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        LabeledTableViewControllerRepresentable()
            .preferredColorScheme(.light)
    }
}
#endif
