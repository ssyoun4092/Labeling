import UIKit
import CoreData

class AddCategoryViewController: UIViewController {
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var calendarDescription: UILabel!
    @IBOutlet weak var timerDescription: UILabel!
    @IBOutlet weak var categoryMainLabelTextField: UITextField!
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    weak var delegate: AddSelectedDateTimeDelegate?
    var keyboardIsPresented: Bool = false
    var iconName = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    var isForEdit: Bool = false
    var categoryForEdit: Category? {
        didSet {
            self.iconName = (categoryForEdit?.iconName)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadCategories()
        setUpButton()
        setUpTextField()
        setUpSwitch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardDidShow() {
        self.keyboardIsPresented = true
    }

    @objc func keyboardDidHide() {
        self.keyboardIsPresented = false
    }

    private func setUpView() {
        self.hideKeyboard()
    }

    private func setUpButton() {
        switch isForEdit {
        case true:
            guard let editCategoryIconName = categoryForEdit?.iconName else { return }
            if editCategoryIconName == "" {
                self.iconButton.setImage(UIImage(), for: .normal)
            } else {
                self.iconButton.setImage(UIImage(systemName: editCategoryIconName), for: .normal)
            }
            self.iconButton.setTitle("", for: .normal)
            self.addButton.setTitle("수정", for: .normal)

        case false:
            self.iconButton.setTitle("Pick Icon!", for: .normal)
            self.iconButton.setImage(UIImage(), for: .normal)
        }
        self.iconButton.layer.cornerRadius = 20
        self.cancelButton.layer.cornerRadius = 5
        self.addButton.layer.cornerRadius = 5
    }

    private func setUpTextField() {
        if isForEdit {
            self.categoryMainLabelTextField.text = categoryForEdit?.mainLabel
        }
    }

    private func setUpSwitch() {
        switch isForEdit {
        case true:
            guard let calendarSwitchIsOn = categoryForEdit?.doCalendar, let timerSwitchIsOn = categoryForEdit?.doTimer else { return }
            self.calendarSwitch.isOn = calendarSwitchIsOn
            self.timerSwitch.isOn = timerSwitchIsOn
            self.calendarSwitch.onTintColor = .systemGray6
            self.timerSwitch.onTintColor = .systemGray6
            self.calendarSwitch.isUserInteractionEnabled = false
            self.timerSwitch.isUserInteractionEnabled = false
            self.calendarDescription.text = "캘린더 기능은 수정이 불가합니다"
            self.timerDescription.text = "시간 기능은 수정이 불가합니다"

        case false:
            self.calendarSwitch.isOn = false
            self.timerSwitch.isOn = false
        }
    }

    private func alertIfCategoryTitleIsDuplicated() {
        let alert = UIAlertController(title: "카테고리 이름이 중복되었어요", message: "다른 이름으로 지어주세요!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK!", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    private func alertIfCategoryTitleIsEmpty() {
        let alert = UIAlertController(title: "카테고리 이름을 반드시 추가해주세요", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK!", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    @IBAction func tapIconButton(_ sender: UIButton) {
        if !keyboardIsPresented {
            guard let iconPickerVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.iconPickerViewConroller) as? IconPickerViewConroller else { return }
            iconPickerVC.passIconDelegate = self
            iconPickerVC.modalPresentationStyle = .overCurrentContext
            iconPickerVC.modalTransitionStyle = .crossDissolve
            present(iconPickerVC, animated: true)
        }
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        if !keyboardIsPresented {
            self.dismiss(animated: true)
        }
    }

    @IBAction func tapAddButton(_ sender: UIButton) {
        if !keyboardIsPresented {
            guard let mainLabel = categoryMainLabelTextField.text else { return }
            switch isForEdit {
            case true:
                if categories.contains(where: { $0.mainLabel == mainLabel }) && mainLabel != categoryForEdit?.mainLabel {
                    alertIfCategoryTitleIsDuplicated()

                    return
                }
                if mainLabel.isEmpty {
                    alertIfCategoryTitleIsEmpty()

                    return
                }
                self.delegate?.modifyCategory(mainLabel: mainLabel, iconName: iconName, index: (categoryForEdit?.index)!)
            case false:
                if categories.contains(where: { $0.mainLabel == mainLabel }) {
                    alertIfCategoryTitleIsDuplicated()

                    return
                }
                if mainLabel.isEmpty {
                    alertIfCategoryTitleIsEmpty()

                    return
                }
                let doesActivateCalendar = calendarSwitch.isOn
                let doesActivateTimer = timerSwitch.isOn
                self.delegate?.addCategory(mainLabel: mainLabel, doCalendar: doesActivateCalendar, doTimer: doesActivateTimer, iconName: self.iconName)
            }
            self.dismiss(animated: true)
        }
    }

    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let sort = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sort]
        do {
            categories = try context.fetch(request)
            print("LoadCategories")
        } catch {
            print("Error loading labels \(error)")
        }
    }

    deinit {
        print("AddCategory Deinit")
    }
}

extension AddCategoryViewController: PassingIconDelegate {
    func passSelectedIcon(name: String) {
        if name == "Pick Icon!" {
            switch isForEdit {
            case true:
                self.iconButton.setImage(UIImage(systemName: iconName), for: .normal)
                self.iconButton.setTitle("", for: .normal)
            case false:
                self.iconButton.setImage(UIImage(), for: .normal)
                self.iconButton.setTitle("Pick Icon!", for: .normal)
            }
        } else if name == "" {
            self.iconButton.setImage(UIImage(), for: .normal)
            self.iconButton.setTitle("", for: .normal)
            self.iconName = name
        } else {
            self.iconButton.setImage(UIImage(systemName: name), for: .normal)
            self.iconButton.setTitle("", for: .normal)
            self.iconName = name
        }
    }
}
