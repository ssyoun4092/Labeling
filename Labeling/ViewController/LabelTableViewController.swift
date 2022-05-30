import UIKit
import CoreData

class LabelTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var labels = [Label]()
    var categories = [Category]()
    var selectedCategory: Category? {
        didSet {
            loadLabels()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "LabelTableCell", bundle: nil), forCellReuseIdentifier: Identifier.labelTableViewCell)
        self.tableView.rowHeight = 100
        loadCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return labels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.labelTableViewCell, for: indexPath) as! LabelTableViewCell
        let label = labels[indexPath.row]
        cell.mainLabel.text = label.title
        if label.date!.isEmpty && !(label.time!.isEmpty) {
            cell.dateLabel.text = label.time
            cell.timeLabel.text = label.date
        } else {
            cell.dateLabel.text = label.date
            cell.timeLabel.text = label.time
        }
        if label.done {
            cell.checkButton.setImage(UIImage(systemName: Icons.checkMark), for: .normal)
        } else {
            cell.checkButton.setImage(UIImage(systemName: Icons.nonCheckMark), for: .normal)
        }
        cell.isDoneDelegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        labels[indexPath.row].done = !labels[indexPath.row].done
        saveLabel()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (action, view, completionHandler) in
            self.removeLabel(indexPath: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let sort = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sort]
        do {
            categories = try context.fetch(request)
            print("LoadCategories")
        } catch {
            print("Error loading labels \(error)")
        }
    }

    private func loadLabels() {
        let request: NSFetchRequest<Label> = Label.fetchRequest()
        let sort = NSSortDescriptor(key: "index", ascending: true)
        let categoryPredicate = NSPredicate(format: "parentCategory.mainLabel MATCHES %@", selectedCategory!.mainLabel!)
        request.sortDescriptors = [sort]
        request.predicate = categoryPredicate
        do {
            labels = try context.fetch(request)
            print("LoadLabels")
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }

    private func removeLabel(indexPath: IndexPath) {
        let row = indexPath.row
        context.delete(labels[row])
        if row == (self.labels.count - 1) {
            self.labels.remove(at: row)
        } else {
            self.labels.remove(at: row)
            for index in (row)...(labels.count - 1) {
                labels[index].index -= Int64(1)
            }
        }
        saveLabel()
    }

    private func saveLabel() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }

    deinit {
        print("LabelTableView Deinit")
    }
}

extension LabelTableViewController: LabelDoneDelegate {
    func changeLabelDoneValue(cell: UITableViewCell) {
        guard let targetIndexPath = self.tableView.indexPath(for: cell) else { return }
        if self.labels[targetIndexPath.row].done {
            self.labels[targetIndexPath.row].done = false
        } else {
            self.labels[targetIndexPath.row].done = true
        }

        saveLabel()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 14.0, *)
struct LabeledTableViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LabelTableViewController

    func makeUIViewController(context: Context) -> LabelTableViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabeledTableViewController") as! LabelTableViewController
    }

    func updateUIViewController(_ uiViewController: LabelTableViewController, context: Context) {

    }
}

@available(iOS 14.0, *)
struct LabeledTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        LabeledTableViewControllerRepresentable()
            .preferredColorScheme(.light)
    }
}
#endif
