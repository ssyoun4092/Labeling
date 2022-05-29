import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let tableList = SettingsSection.createSection()
    let firstSectionSettingDetailVC: [UIViewController] = [ThemeSelectViewController()]
    let settingDetailVC = [ThemeSelectViewController.self, IconPickerViewConroller.self]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName: "SettingsTableCell", bundle: nil), forCellReuseIdentifier: DarkModeSettingCell.identifier)
    }

    func navigateTargetSettingDetailVC(indexPath: IndexPath) {
        let targetVC = firstSectionSettingDetailVC[0]
    }

    deinit {
        print("Settings Deinit")
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
        cell.backgroundColor = Color.cellBackgroundColor

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
        if indexPath.row == 0 {
            guard let targetVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.NoticeViewController) as? NoticeViewController else { return }
            self.navigationController?.pushViewController(targetVC, animated: true)
        } else if indexPath.row == 1 {
            guard let targetVC = self.storyboard?.instantiateViewController(withIdentifier: ThemeSelectViewController.identifier) as? ThemeSelectViewController else { return }
            self.navigationController?.pushViewController(targetVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
