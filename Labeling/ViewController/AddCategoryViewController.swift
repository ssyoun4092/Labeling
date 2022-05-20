import UIKit

class AddCategoryViewController: UIViewController {
    static let identifier = "AddCategoryViewController"
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var alertview: UIView!
    @IBOutlet weak var categoryMainLabelTextField: UITextField!
    @IBOutlet weak var categorySubLabelTextField: UITextField!
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    var delegate: AddCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        initBackgroundView()
    }
    private func initBackgroundView() {
        let tapForDismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.backgroundView.addGestureRecognizer(tapForDismissView)
    }

    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        guard let mainLabel = categoryMainLabelTextField.text else { return }
        guard let subLabel = categorySubLabelTextField.text else { return }
        let doesActivateCalendar = calendarSwitch.isOn
        let doesActivateTimer = timerSwitch.isOn
        self.delegate?.addCategory(mainLabel: mainLabel, subLabel: subLabel, doCalendar: doesActivateCalendar, doTimer: doesActivateTimer)
        self.dismiss(animated: true)
    }
}
