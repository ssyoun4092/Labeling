import UIKit
import FSCalendar

class SelectDateViewController: UIViewController {
    static let identifier = "SelectDateViewController"
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var calendarBackgroundView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var addDateDelegate: AddSelectedProperty?
    var selectedDate: Date?
    var nextButtonText: String = "Choose Time"
    var choosenCellIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.weekdayTextColor = .black
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.todaySelectionColor = .systemRed
        calendarView.appearance.selectionColor = .systemPurple
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func tapNextButton(_ sender: UIButton) {
        guard let selectedDate = selectedDate else { return }
        let dateString = convertDateToString(date: selectedDate)
        print(selectedDate)
        if self.nextButton.titleLabel?.text == "Choose Time" {
            guard let selectTimeVC = self.storyboard?.instantiateViewController(withIdentifier: SelectTimeViewController.identifier) as? SelectTimeViewController else { return }
            self.addDateDelegate?.addSelectedDateToLabel(date: dateString)
            selectTimeVC.categoryCellIndexPath = self.choosenCellIndexPath
            selectTimeVC.doesComeFromSelectDateVC = true
            selectTimeVC.passTimeDelegate = self
            selectTimeVC.modalPresentationStyle = .overCurrentContext
            selectTimeVC.modalTransitionStyle = .crossDissolve
            self.present(selectTimeVC, animated: true)
        } else {
            self.addDateDelegate?.saveSelectedDateToLabel(date: dateString, indexPath: choosenCellIndexPath)
            self.dismiss(animated: true)
        }
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

extension SelectDateViewController: PassTimeToSelectDateVC {
    func passTimeData(time: String, indexPath: IndexPath?) {
        self.addDateDelegate?.saveSelectedTimeToLabel(time: time, indexPath: indexPath)
    }
}
