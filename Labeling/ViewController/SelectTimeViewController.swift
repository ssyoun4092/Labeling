import UIKit

class SelectTimeViewController: UIViewController {
    static let identifier = "SelectTimeViewController"
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var selectedTime: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        initBlurView()
        setUpPickerContainerview()
        setUpTimePicker()
        setUpButtons()
    }

    func initBlurView() {
        let tapForDismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.blurView.addGestureRecognizer(tapForDismissView)
    }

    func setUpPickerContainerview() {
        pickerContainerView.layer.cornerRadius = 10
    }

    func setUpTimePicker() {
        self.timePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
    }

    func setUpButtons() {
        cancelButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
    }

    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }

    @objc func timePickerValueChanged(_ datePicker: UIDatePicker) {
        selectedTime = datePicker.date
        print(selectedTime)
//        guard let selectedTime = selectedTime else {
//            return
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let selectedTimeString = formatter.string(from: selectedTime)
//        print(selectedTimeString)
    }
}
