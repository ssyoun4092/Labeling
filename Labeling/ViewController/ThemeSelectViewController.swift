import UIKit

class ThemeSelectViewController: UIViewController {
    let themeList: [String] = ["라이트 모드", "다크 모드", "시스템 모드"]
    let appDelegate = UIApplication.shared.windows.first
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "테마 설정"
        initTableView()
    }

    func initTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension ThemeSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return themeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectCell", for: indexPath)
        cell.textLabel?.text = themeList[indexPath.row]
        switch userDefaults.string(forKey: "Theme") {
        case "light":
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case "dark":
            if indexPath.row == 1 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case "system", nil:
            if indexPath.row == 2 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        default :
            print("")
        }

        return cell
    }
}

extension ThemeSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("Light!")
            appDelegate?.overrideUserInterfaceStyle = .light
            userDefaults.set("light", forKey: "Theme")
        } else if indexPath.row == 1 {
            print("Dark!")
            appDelegate?.overrideUserInterfaceStyle = .dark
            userDefaults.set("dark", forKey: "Theme")
        } else if indexPath.row == 2 {
            print("System!")
            appDelegate?.overrideUserInterfaceStyle = .unspecified
            userDefaults.set("system", forKey: "Theme")
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
