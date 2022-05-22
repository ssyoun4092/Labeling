import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let tableList = SettingsSection.createSection()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tableList[section].cell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target = tableList[indexPath.section].cell[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTable", for: indexPath)
        cell.textLabel?.text = target.title
        cell.accessoryType = target.hasIndicator ? .disclosureIndicator : .none

        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 24))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = tableList[section].header

        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 61
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = cell?.backgroundColor == .red ? .blue : .red
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
