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
        self.tableView.register(UINib(nibName: "SettingsTableCell", bundle: nil), forCellReuseIdentifier: Identifier.darkModeSettingCell)
    }

    private func goToDM() {
        let myInstaName = "say_young01"
        guard let targetURL = URL(string: "instagram://user?username=\(myInstaName)") else { return }
        let application = UIApplication.shared

        if application.canOpenURL(targetURL) {
            application.open(targetURL)
        } else {
            guard let webURL = URL(string: "https://instagram.com/\(myInstaName)") else { return }
            application.open(webURL)
        }
    }

    private func goToAppRating() {
        let myAppID = "1626607752"
        let myAppstoreURL = "itms-apps://itunes.apple.com/app/id\(myAppID)?mt=8&action=write-review"
        guard let url = URL(string: myAppstoreURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.contentView.backgroundColor = .clear
        switch (indexPath.row, indexPath.section) {
        case (0, 0):
            guard let targetVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.noticeViewController) as? NoticeViewController else { return }
            self.navigationController?.pushViewController(targetVC, animated: true)

        case (1, 0):
            guard let targetVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.themeSelectViewController) as? ThemeSelectViewController else { return }
            self.navigationController?.pushViewController(targetVC, animated: true)

        case (0, 1):
            goToDM()

        case (1, 1):
            goToAppRating()

        case (2, 1):
            guard let onboardingVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.onboardingViewController) as? OnboardingViewController else { return }
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: false)

        default:
            print("No Value")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
