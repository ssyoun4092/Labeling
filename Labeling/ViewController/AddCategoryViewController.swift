import UIKit

class AddCategoryViewController: UIViewController {
    static let identifier = "AddCategoryViewController"
//    @IBOutlet weak var blurView: UIView!
//    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var categoryMainLabelTextField: UITextField!
    @IBOutlet weak var categorySubLabelTextField: UITextField!
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    var delegate: AddSelectedProperty?
    var iconName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIconButton()
    }

    func setUpIconButton() {
        self.iconButton.setTitle("Pick Icons!", for: .normal)
        self.iconButton.setImage(UIImage(), for: .normal)
    }

    @IBAction func tapIconButton(_ sender: UIButton) {
        guard let iconPickerVC = self.storyboard?.instantiateViewController(withIdentifier: IconPickerViewConroller.idenfier) as? IconPickerViewConroller else { return }
        iconPickerVC.passIconDelegate = self
        iconPickerVC.modalPresentationStyle = .overCurrentContext
        iconPickerVC.modalTransitionStyle = .crossDissolve
        present(iconPickerVC, animated: true)
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        guard let mainLabel = categoryMainLabelTextField.text else { return }
        guard let subLabel = categorySubLabelTextField.text else { return }
        let doesActivateCalendar = calendarSwitch.isOn
        let doesActivateTimer = timerSwitch.isOn
        print("\(self.iconName)")
        self.delegate?.addCategory(mainLabel: mainLabel, subLabel: subLabel, doCalendar: doesActivateCalendar, doTimer: doesActivateTimer, iconName: self.iconName)
        self.dismiss(animated: true)
    }
}

extension AddCategoryViewController: PassingIconDelegate {
    func passSelectedIcon(name: String) {
        if name == "" {
            self.iconButton.setImage(UIImage(), for: .normal)
            self.iconButton.setTitle("", for: .normal)
        } else {
            self.iconButton.setImage(UIImage(systemName: name), for: .normal)
            self.iconButton.setTitle("", for: .normal)
            self.iconName = name
        }
    }
}
