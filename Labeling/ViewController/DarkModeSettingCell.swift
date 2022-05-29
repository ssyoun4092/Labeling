import UIKit

class DarkModeSettingCell: UITableViewCell {
    static let identifier = "DarkModeSettingCell"
    @IBOutlet weak var darkModeSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDarkModeSwitch()
    }

    func setUpDarkModeSwitch() {
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first

            if appDelegate?.overrideUserInterfaceStyle == .light {
                darkModeSwitch.isOn = false
            } else if appDelegate?.overrideUserInterfaceStyle == .dark {
                darkModeSwitch.isOn = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func tapDarkModeSwitch(_ sender: UISwitch) {
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first

            if sender.isOn {
                appDelegate?.overrideUserInterfaceStyle = .dark

                return
            }

            appDelegate?.overrideUserInterfaceStyle = .light
        }
    }
}
