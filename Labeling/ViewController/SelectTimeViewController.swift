import UIKit

class SelectTimeViewController: UIViewController {
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    var selectedTime: Date?
    var doesComeFromSelectDateVC: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectTimeVC Did Load")
        initBlurView()
        setUpPickerContainerview()
        setUpTimePicker()
        setUpButtons()
    }

    private func initBlurView() {
        let tapForDismissPresentedView = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedView))
        self.blurView.addGestureRecognizer(tapForDismissPresentedView)
    }

    private func setUpPickerContainerview() {
        pickerContainerView.layer.cornerRadius = 10
    }

    private func setUpTimePicker() {
        self.timePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
    }

    private func setUpButtons() {
        cancelButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        if doesComeFromSelectDateVC {
            guard let selectedDateVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.selectDateViewController) as? SelectDateViewController else { return }
            selectedDateVC.modalTransitionStyle = .crossDissolve
            selectedDateVC.modalPresentationStyle = .overCurrentContext
            guard let categoryVC = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                categoryVC.present(selectedDateVC, animated: true)
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("cancelButtonTapped"), object: nil)
            self.dismiss(animated: true)
        }
    }

    @IBAction func tapSaveButton(_ sender: UIButton) {
        guard let selectedTime = selectedTime else { return alertIfTimeNotSelected() }
        saveSelectedTimeInLabel(time: selectedTime)
        self.dismiss(animated: true)
    }

    private func convertTimeToString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시 mm분"
        let timeString = dateFormatter.string(from: time)

        return timeString
    }

    private func saveSelectedTimeInLabel(time: Date) {
        let convertedTime = convertTimeToString(time: time)
        NotificationCenter.default.post(name: NSNotification.Name("saveTime"), object: convertedTime)
    }

    private func alertIfTimeNotSelected() {
        let alert = UIAlertController(title: "시간을 선택해주세요!", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    @objc func dismissPresentedView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @objc func timePickerValueChanged(_ datePicker: UIDatePicker) {
        selectedTime = datePicker.date
    }

    deinit {
        print("SelectTimeVC Deinit")
    }
}
