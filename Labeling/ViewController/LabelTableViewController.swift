import UIKit
import CoreData

class LabelTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var labels = [Label]()
    var selectedCategory: Category? {
        didSet {
            loadLabels()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return labels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabellCell", for: indexPath)
        let label = labels[indexPath.row]
        cell.textLabel?.text = label.title
        cell.accessoryType = label.done ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        labels[indexPath.row].done = !labels[indexPath.row].done
        saveLabel()
        tableView.deselectRow(at: indexPath, animated: true)
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

    private func saveLabel() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
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
