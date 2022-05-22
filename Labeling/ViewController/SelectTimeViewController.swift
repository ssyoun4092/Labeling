import UIKit

protocol PassTimeToSelectDateVC {
    func passTimeData(time: String, indexPath: IndexPath?)
}

class SelectTimeViewController: UIViewController {
    static let identifier = "SelectTimeViewController"
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    var passTimeDelegate: PassTimeToSelectDateVC?
    var saveTimeDelegate: AddSelectedProperty?
    var selectedTime: Date = Date()
    var categoryCellIndexPath: IndexPath?
    var doesComeFromSelectDateVC: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initBlurView()
        setUpPickerContainerview()
        setUpTimePicker()
        setUpButtons()
    }

    func initBlurView() {
        let tapForDismissPresentedView = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedView))
        self.blurView.addGestureRecognizer(tapForDismissPresentedView)
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
    @IBAction func tapCancelButton(_ sender: UIButton) {

    }

    @IBAction func tapSaveButton(_ sender: UIButton) {
        let timeString = convertTimeToString(time: selectedTime)
        print("\(timeString) in SelectTimeVC")
        if doesComeFromSelectDateVC {
            self.passTimeDelegate?.passTimeData(time: timeString, indexPath: categoryCellIndexPath)
        } else {
            self.saveTimeDelegate?.saveSelectedTimeToLabel(time: timeString, indexPath: categoryCellIndexPath)
        }
    }

    func convertTimeToString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH시 mm분"
        let timeString = dateFormatter.string(from: time)

        return timeString
    }

    @objc func dismissPresentedView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }

    @objc func timePickerValueChanged(_ datePicker: UIDatePicker) {
        selectedTime = datePicker.date
    }
}
