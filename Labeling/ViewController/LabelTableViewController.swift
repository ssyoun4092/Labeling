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
        self.tableView.register(UINib(nibName: "NoLabelPlaceholderTableCell", bundle: nil), forCellReuseIdentifier: Identifier.noLabelPlaceholderTableViewCell)
        self.title = selectedCategory?.mainLabel
        loadCategories()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if labels.count == 0 {

            return 1
        } else {

            return labels.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let labelCell = tableView.dequeueReusableCell(withIdentifier: Identifier.labelTableViewCell, for: indexPath) as! LabelTableViewCell
        let placeholderCell = tableView.dequeueReusableCell(withIdentifier: Identifier.noLabelPlaceholderTableViewCell) as! NoLabelPlaceholderTableViewCell
        placeholderCell.isUserInteractionEnabled = false

        if labels.count == 0 {
            self.tableView.rowHeight = (self.tableView.bounds.height / 2)

            return placeholderCell
        } else {
            self.tableView.rowHeight = 100
            let label = labels[indexPath.row]
            labelCell.mainLabel.text = label.title
            if label.date!.isEmpty && !(label.time!.isEmpty) {
                labelCell.dateLabel.text = label.time
                labelCell.timeLabel.text = label.date
            } else {
                labelCell.dateLabel.text = label.date
                labelCell.timeLabel.text = label.time
            }
            if label.done {
                labelCell.checkButton.setImage(UIImage(systemName: Icons.checkMark), for: .normal)
            } else {
                labelCell.checkButton.setImage(UIImage(systemName: Icons.nonCheckMark), for: .normal)
            }
            labelCell.isDoneDelegate = self

            return labelCell
        }
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
        if !(labels.count == 0) {
            let deleteAction = UIContextualAction(style: .normal, title: "삭제") { (action, view, completionHandler) in
                self.removeLabel(indexPath: indexPath)
                completionHandler(true)
                print("deleteAction")
                self.tableView.reloadData()
            }
            deleteAction.backgroundColor = .systemRed

            return UISwipeActionsConfiguration(actions: [deleteAction])
        }

        return nil
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
