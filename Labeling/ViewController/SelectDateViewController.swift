import UIKit
import FSCalendar

class SelectDateViewController: UIViewController {
    static let identifier = "SelectDateViewController"
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var calendarBackgroundView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var chooseTimeButton: UIButton!

    var selectedDate: Date?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.dismissView(byTapping: blurView)
        setUpCalendarBackgroundView()
        setUpCalendar()
        setUpButtons()
    }

//    private func initBlurView() {
//        let tapForDismissView = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//        self.blurView.addGestureRecognizer(tapForDismissView)
//    }

    private func setUpCalendarBackgroundView() {
        self.calendarBackgroundView.layer.cornerRadius = 10
    }

    private func setUpCalendar() {
        calendarView.scrollEnabled = true
        calendarView.scrollDirection = .horizontal
        setUpCalendarAppearance()

    }

    private func setUpButtons() {
        self.cancelButton.layer.cornerRadius = 5
        self.chooseTimeButton.layer.cornerRadius = 5
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

//    @objc func dismissView(_ sender: UITapGestureRecognizer) {
//        self.dismiss(animated: true)
//    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func tapChooseTimeButton(_ sender: UIButton) {
//        self.dismiss(animated: false)
        guard let selectedDate = selectedDate else { return }
        print(selectedDate)
        guard let selectTimeViewController = self.storyboard?.instantiateViewController(withIdentifier: SelectTimeViewController.identifier) as? SelectTimeViewController else { return }
        selectTimeViewController.modalPresentationStyle = .overCurrentContext
        selectTimeViewController.modalTransitionStyle = .crossDissolve
        self.present(selectTimeViewController, animated: true)
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
