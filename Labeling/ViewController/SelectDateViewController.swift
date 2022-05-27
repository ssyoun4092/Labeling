import UIKit
import FSCalendar

class SelectDateViewController: UIViewController {
    static let identifier = "SelectDateViewController"
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var calendarBackgroundView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var selectedDate: Date?
    var nextButtonText: String = "Choose Time"

    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectDateVC Did Load")
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.dismissView(byTapping: blurView)
        setUpCalendarBackgroundView()
        setUpCalendar()
        setUpButtons()
    }

    private func setUpCalendarBackgroundView() {
        self.calendarBackgroundView.layer.cornerRadius = 10
    }

    private func setUpCalendar() {
        calendarView.scrollEnabled = true
        calendarView.scrollDirection = .horizontal
        setUpCalendarAppearance()
    }

    private func setUpButtons() {
        self.nextButton.setTitle(nextButtonText, for: .normal)
        self.nextButton.tintColor = UIColor.white
        self.cancelButton.layer.cornerRadius = 5
        self.nextButton.layer.cornerRadius = 5
    }

    private func setUpCalendarAppearance() {
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.headerTitleColor = Color.textColor
        calendarView.appearance.weekdayTextColor = Color.textColor
        calendarView.appearance.titleDefaultColor = Color.textColor
        calendarView.backgroundColor = Color.cellBackgroundColor
        calendarView.appearance.titleWeekendColor = .systemRed
        calendarView.appearance.todaySelectionColor = .systemRed
        calendarView.appearance.selectionColor = Color.accentColor
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("cancelButtonTapped"), object: nil)
        self.dismiss(animated: true)
    }

    @IBAction func tapNextButton(_ sender: UIButton) {
        guard let selectedDate = selectedDate else {
            return  alertIfDateNotSelected()
        }
        if self.nextButton.titleLabel?.text == "Choose Time" {
            guard let selectTimeVC = self.storyboard?.instantiateViewController(withIdentifier: SelectTimeViewController.identifier) as? SelectTimeViewController else { return }
            selectTimeVC.doesComeFromSelectDateVC = true
            postSelectedDateToObserver(date: selectedDate)
            selectTimeVC.modalPresentationStyle = .overCurrentContext
            selectTimeVC.modalTransitionStyle = .crossDissolve
            guard let categoryVC = self.presentingViewController else { return }
            self.dismiss(animated: false) {
                categoryVC.present(selectTimeVC, animated: true)
            }
        } else {
            saveSelectedDateInLabel(date: selectedDate)
            self.dismiss(animated: true)
        }
    }

    private func alertIfDateNotSelected() {
        let alert = UIAlertController(title: "날짜를 선택해주세요!", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    private func postSelectedDateToObserver(date: Date) {
        let convertedDate = convertDateToString(date: date)
        NotificationCenter.default.post(name: NSNotification.Name("addDate"), object: convertedDate)
    }

    private func saveSelectedDateInLabel(date: Date) {
        let convertedDate = convertDateToString(date: date)
        NotificationCenter.default.post(name: NSNotification.Name("saveDate"), object: convertedDate)
    }

    private func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }

    deinit {
        print("SelectDateViewController Deinit")
    }
}

extension SelectDateViewController: FSCalendarDataSource {
    
}

extension SelectDateViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
    }
}
