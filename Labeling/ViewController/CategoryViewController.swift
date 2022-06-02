import UIKit
import CoreData

enum CurrentMode {
    case normal
    case edit
}

class CategoryViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!

    var textFieldOrigin: CGPoint = CGPoint()
    var isLabelOnCell: Bool = false
    var keyboardIsPresented: Bool = false
    weak var currentModeDelegate: CategoryViewControllerDelegate?
    var currentMode: CurrentMode = .normal
    var categories = [Category]()
    lazy var firstLaunchCategories: [FirstLaunchCategory] = [thinkingLabel, assignmentLabel, wantToEatLabel, deadlineLabel, appointmentLabel]
    var isGestureOnCell: Bool? {
        didSet {
            print("isGestureOnCell DidSet")
            for row in 0...(categories.count - 1) {
                self.collectionView.cellForItem(at: IndexPath(row: row, section: 0))?.backgroundColor = Color.cellBackgroundColor
            }
        }
    }
    var labels = [Label]()
    var tempLabel: [String: Any] = ["title": "", "date": "", "time": "", "cellIndexPath": IndexPath()]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        initCollectionView()
        initView()
        setUpCollectionView()
        loadCategoriesFirstAppLaunch()
        loadCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLabelTextField()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addDate(_:)), name: NSNotification.Name("addDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDate(_: )), name: NSNotification.Name("saveDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveTime(_: )), name: NSNotification.Name("saveTime"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveTitle(_: )), name: NSNotification.Name("saveTitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveIndexPath(_:)), name: NSNotification.Name("saveIndexPath"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetTappedCancel(_:)), name: NSNotification.Name("cancelButtonTapped"), object: nil)
        self.collectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("addDate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("saveDate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("saveTime"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("saveTitle"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("saveIndexPath"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("cancelButtonTapped"), object: nil)
    }

    //MARK: - Setup View
    private func initView() {
        self.hideKeyboard()
        self.currentModeDelegate = self
    }

    private func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        self.collectionView.isUserInteractionEnabled = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
        self.collectionView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier.categoryViewCell)
        self.collectionView.register(UINib(nibName: "AddCategoryViewCell", bundle: nil), forCellWithReuseIdentifier: Identifier.addCategoryViewCell)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }

    private func setUpCollectionView() {
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.layer.shadowColor = CGColor(gray: 1, alpha: 0.5)
        self.collectionView.layer.shadowOffset = CGSize(width: 100, height: 100)
    }

    private func setUpLabelTextField() {
        textFieldOrigin = self.labelTextField.frame.origin
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragGesture))
        self.labelTextField.delegate = self
        self.labelTextField.isUserInteractionEnabled = true
        self.labelTextField.addGestureRecognizer(dragGesture)
        self.labelTextField.layer.cornerRadius = 20
        self.labelTextField.backgroundColor = Color.cellBackgroundColor
        self.labelTextField.addShadow()
        self.labelTextField.text?.removeAll()
        self.labelTextField.layer.masksToBounds = false
    }

    //MARK: - Gesture functions
    @objc func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.labelTextField.superview)
        let changedXPoint = self.labelTextField.center.x + translation.x
        let changedYPoint = self.labelTextField.center.y + translation.y
        if !(labelTextField.text!.isEmpty) && !(self.currentMode == .edit) {
            switch gesture.state {
            case .began:
                self.view.endEditing(true)
            case .changed :
                self.labelTextField.center = CGPoint(x: changedXPoint, y: changedYPoint)
                let indexPath = calculateCellIndexPath(on: self.labelTextField.center)
                if indexPath.row == 6 {
                    disableAllCellColor()
                } else {
                    disableCellColorExcept(At: indexPath)
                }
                self.isLabelOnCell = isGestureOnCell(At: indexPath)
            case .ended :
                let indexPath = calculateCellIndexPath(on: self.labelTextField.center)
                disableAllCellColor()
                animateOut()
                if !(indexPath.row == 6) {
                    self.tempLabel["cellIndexPath"] = indexPath
                    saveTitleInTempLabel(title: self.labelTextField.text)
                    presentSelectViewConroller(indexPath: indexPath)
                }
                print("=====")
            default:
                break
            }
            gesture.setTranslation(.zero, in: self.labelTextField)
        }
    }

    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if currentMode == .edit {
            guard let collectionView = collectionView else { return }
            switch gesture.state {
            case .began:
                guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            case .changed:
                let gestureLocation = gesture.location(in: collectionView)
                let modifiedGestureLocation = modifyGestureLocationIfGoesOffFromCollectioViewBounds(gestureLocation)
                collectionView.updateInteractiveMovementTargetPosition(modifiedGestureLocation)
            case .ended:
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
        }
    }

    @objc func addDate(_ notification: Notification) {
        guard let passedDate = notification.object as? String else { return }
        self.tempLabel["date"] = passedDate
    }

    @objc func saveDate(_ notification: Notification) {
        guard let passedDate = notification.object as? String else { return }
        guard let indexPath = self.tempLabel["cellIndexPath"] as? IndexPath else { return }
        self.tempLabel["date"] = passedDate
        addLabelToCategory(At: indexPath)
    }

    @objc func saveTime(_ notification: Notification) {
        guard let passedTime = notification.object as? String else { return }
        guard let indexPath = self.tempLabel["cellIndexPath"] as? IndexPath else { return }
        self.tempLabel["time"] = passedTime
        addLabelToCategory(At: indexPath)
    }

    @objc func saveTitle(_ notification: Notification) {
        guard let passedTitle = notification.object as? String else { return }
        self.tempLabel["title"] = passedTitle
    }

    @objc func saveIndexPath(_ notification: Notification) {
        guard let passedIndexPath = notification.object as? IndexPath else { return }
        self.tempLabel["cellIndexPath"] = passedIndexPath
    }

    @objc func resetTappedCancel(_ notification: Notification) {
        resetTempLabel()
    }

    //MARK: - Handling Keyboard
    @objc func keyboardDidShow() {
        self.keyboardIsPresented = true
    }

    @objc func keyboardDidHide() {
        self.keyboardIsPresented = false
    }

    //MARK: - Handling Cell
    private func calculateCellIndexPath(on point: CGPoint) -> IndexPath {
        let currentCellCount = self.categories.count
        let collectionViewOrigin = collectionView.frame.origin
        let collectionViewWidth = collectionView.frame.size.width
        let collectionViewHeight = collectionView.frame.size.height
        let spacing: CGFloat = 10
        let cellHeight = (collectionViewHeight - (2 * spacing)) / 3
        let x1Point = collectionViewOrigin.x
        let x2Point = collectionViewOrigin.x + (collectionViewWidth / 2)
        let x3Point = collectionViewOrigin.x + (collectionViewWidth / 2) + spacing
        let x4Point = collectionViewOrigin.x + collectionViewWidth
        let y1Point = collectionViewOrigin.y
        let y2Point = collectionViewOrigin.y + cellHeight
        let y3Point = collectionViewOrigin.y + cellHeight + spacing
        let y4Point = collectionViewOrigin.y + (2 * cellHeight) + spacing
        let y5Point = collectionViewOrigin.y + (2 * cellHeight) + (2 * spacing)
        let y6Point = collectionViewOrigin.y + collectionViewHeight
        var indexPath = IndexPath()

        switch currentCellCount {
        case 1:
            if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 0, section: 0)
            } else {
                indexPath = IndexPath(row: 6, section: 0)
            }
        case 2:
            if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 0, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 1, section: 0)
            } else {
                indexPath = IndexPath(row: 6, section: 0)
            }
        case 3:
            if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 0, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 1, section: 0)
            } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 2, section: 0)
            } else {
                indexPath = IndexPath(row: 6, section: 0)
            }
        case 4:
            if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 0, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 1, section: 0)
            } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 2, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 3, section: 0)
            } else {
                indexPath = IndexPath(row: 6, section: 0)
            }
        case 5:
            if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 0, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 1, section: 0)
            } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 2, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 3, section: 0)
            } else if point.x >= x1Point && point.x <= x2Point && point.y >= y5Point && point.y <= y6Point {
                indexPath = IndexPath(row: 4, section: 0)
            } else {
                indexPath = IndexPath(row: 6, section: 0)
            }
        case 6:
            if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 0, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
                indexPath = IndexPath(row: 1, section: 0)
            } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 2, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y3Point && point.y <= y4Point {
                indexPath = IndexPath(row: 3, section: 0)
            } else if point.x >= x1Point && point.x <= x2Point && point.y >= y5Point && point.y <= y6Point {
                indexPath = IndexPath(row: 4, section: 0)
            } else if point.x >= x3Point && point.x <= x4Point && point.y >= y5Point && point.y <= y6Point {
                indexPath = IndexPath(row: 5, section: 0)
            } else {
                indexPath = IndexPath(row: 6, section: 0)
            }
        default:
            print("Default")
        }

        return indexPath
    }

    private func modifyGestureLocationIfGoesOffFromCollectioViewBounds(_ gestureLocation: CGPoint) -> CGPoint {
        var modifiedGestureLocation = CGPoint()
        let numberOfCells = (categories.count == 6) ? 6 : (categories.count + 1)
        let cellWidth = (self.collectionView.bounds.size.width - 10) / 2
        let halfCellWidth = cellWidth / 2
        let cellHeight = (self.collectionView.bounds.size.height - 20) / 3
        let halfCellHeight = cellHeight / 2
        let spacing: CGFloat = 10
        let spacingCellVertically = cellWidth + spacing
        let spacingCellHorizontally = cellHeight + spacing

        let firstCellCenterPoint = CGPoint(x: halfCellWidth, y: halfCellHeight)
        let secondCellCenterPoint = CGPoint(x: halfCellWidth +  spacingCellVertically, y: halfCellHeight)
        let thirdCellCenterPoint = CGPoint(x: halfCellWidth, y: halfCellHeight + spacingCellHorizontally)
        let fourthCellCenterPoint = CGPoint(x: halfCellWidth + spacingCellVertically, y: halfCellHeight + spacingCellHorizontally)
        let fifthCellCenterPoint = CGPoint(x: halfCellWidth, y: halfCellHeight + (spacingCellHorizontally * 2))
        let sixthCellCenterPoint = CGPoint(x: halfCellWidth + spacingCellVertically, y: halfCellHeight + (spacingCellHorizontally * 2))

        switch numberOfCells {
        case 1, 2:
            if gestureLocation.x < firstCellCenterPoint.x {
                modifiedGestureLocation = CGPoint(x: firstCellCenterPoint.x, y: firstCellCenterPoint.y)
            } else if gestureLocation.x > secondCellCenterPoint.x {
                modifiedGestureLocation = CGPoint(x: secondCellCenterPoint.x, y: secondCellCenterPoint.y)

            } else if gestureLocation.y < firstCellCenterPoint.y || gestureLocation.y > firstCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: gestureLocation.x, y: firstCellCenterPoint.y)
            } else {
                modifiedGestureLocation = gestureLocation
            }

        case 3, 4:
            if gestureLocation.x < firstCellCenterPoint.x && gestureLocation.y < firstCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: firstCellCenterPoint.x, y: firstCellCenterPoint.y)
            } else if gestureLocation.x > secondCellCenterPoint.x && gestureLocation.y < secondCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: secondCellCenterPoint.x, y: secondCellCenterPoint.y)
            } else if gestureLocation.x < thirdCellCenterPoint.x && gestureLocation.y > thirdCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: thirdCellCenterPoint.x, y: thirdCellCenterPoint.y)
            } else if gestureLocation.x > fourthCellCenterPoint.x && gestureLocation.y > fourthCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: fourthCellCenterPoint.x, y: fourthCellCenterPoint.y)
            } else if gestureLocation.y < firstCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: gestureLocation.x, y: firstCellCenterPoint.y)
            } else if gestureLocation.y > thirdCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: gestureLocation.x, y: thirdCellCenterPoint.y)
            } else if gestureLocation.x < firstCellCenterPoint.x {
                modifiedGestureLocation = CGPoint(x: firstCellCenterPoint.x, y: gestureLocation.y)
            } else if gestureLocation.x > secondCellCenterPoint.x {
                modifiedGestureLocation = CGPoint(x: secondCellCenterPoint.x, y: gestureLocation.y)
            } else {
                modifiedGestureLocation = gestureLocation
            }

        case 5, 6:
            if gestureLocation.x < firstCellCenterPoint.x && gestureLocation.y < firstCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: firstCellCenterPoint.x, y: firstCellCenterPoint.y)
            } else if gestureLocation.x > secondCellCenterPoint.x && gestureLocation.y < secondCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: secondCellCenterPoint.x, y: secondCellCenterPoint.y)
            } else if gestureLocation.x < fifthCellCenterPoint.x && gestureLocation.y > fifthCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: fifthCellCenterPoint.x, y: fifthCellCenterPoint.y)
            } else if gestureLocation.x > sixthCellCenterPoint.x && gestureLocation.y > sixthCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: sixthCellCenterPoint.x, y: sixthCellCenterPoint.y)
            } else if gestureLocation.y < firstCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: gestureLocation.x, y: firstCellCenterPoint.y)
            } else if gestureLocation.y > fifthCellCenterPoint.y {
                modifiedGestureLocation = CGPoint(x: gestureLocation.x, y: fifthCellCenterPoint.y)
            } else if gestureLocation.x < firstCellCenterPoint.x {
                modifiedGestureLocation = CGPoint(x: firstCellCenterPoint.x, y: gestureLocation.y)
            } else if gestureLocation.x > secondCellCenterPoint.x {
                modifiedGestureLocation = CGPoint(x: secondCellCenterPoint.x, y: gestureLocation.y)
            } else {
                modifiedGestureLocation = gestureLocation
            }

        default:
            print("")
        }

        return modifiedGestureLocation
    }

    private func isGestureOnCell(At indexPath: IndexPath) -> Bool {
        if indexPath.row == 6 {

            return false
        } else {

            return true
        }
    }

    private func presentSelectViewConroller(indexPath: IndexPath) {
        if categories[indexPath.row].doCalendar && categories[indexPath.row].doTimer {
            guard let selectDateVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.selectDateViewController) as? SelectDateViewController else { return }
            selectDateVC.modalPresentationStyle = .overCurrentContext
            selectDateVC.modalTransitionStyle = .crossDissolve
            self.present(selectDateVC, animated: true)
        } else if (categories[indexPath.row].doCalendar == true) && (categories[indexPath.row].doTimer == false) {
            guard let selectDateVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.selectDateViewController) as? SelectDateViewController else { return }
            selectDateVC.nextButtonText = "Save"
            selectDateVC.modalPresentationStyle = .overCurrentContext
            selectDateVC.modalTransitionStyle = .crossDissolve
            self.present(selectDateVC, animated: true)
        } else if (categories[indexPath.row].doCalendar == false) && (categories[indexPath.row].doTimer == true) {
            guard let selectTimeVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.selectTimeViewController) as? SelectTimeViewController else { return }
            selectTimeVC.modalPresentationStyle = .overCurrentContext
            selectTimeVC.modalTransitionStyle = .crossDissolve
            self.present(selectTimeVC, animated: true)
        } else {
            addLabelToCategory(At: indexPath)
            resetTempLabel()
        }
    }

    private func disableAllCellColor() {
        for cellRow in (0...(categories.count - 1)) {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: cellRow, section: 0)) as? CategoryViewCell else { return }
            cell.backgroundColor = Color.cellBackgroundColor
            cell.calendarButton.tintColor = Color.mainTextColor
            cell.timerButton.tintColor = Color.mainTextColor
        }
    }

    private func disableCellColorExcept(At indexPath: IndexPath) {
        let row = indexPath.row
        guard let cellOnGesture = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CategoryViewCell else { return }
        cellOnGesture.backgroundColor = Color.cellHighlightColor
        cellOnGesture.calendarButton.tintColor = Color.mainTextColor
        cellOnGesture.timerButton.tintColor = Color.mainTextColor
        var array: [Int] = []
        array.append(contentsOf: 0...(categories.count - 1))
        array.remove(at: row)
        for (_, cellRow) in array.enumerated() {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: cellRow, section: 0)) as? CategoryViewCell else { return }
            cell.backgroundColor = Color.cellBackgroundColor
            cell.calendarButton.tintColor = Color.mainTextColor
            cell.timerButton.tintColor = Color.mainTextColor
        }
    }
    
    private func animateOut() {
        if isLabelOnCell {
            self.labelTextField.animateTiny()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.labelTextField.disappear()
                self.labelTextField.animateAppearAt(initialOrigin: self.textFieldOrigin)
            }
        } else {
            self.labelTextField.disappear()
            self.labelTextField.animateAppearAt(initialOrigin: self.textFieldOrigin)
        }
    }

    //MARK: - Handling Coredata
    private func loadCategoriesFirstAppLaunch() {
        if UIApplication.isFirstLaunch() {
            for count in 0...(firstLaunchCategories.count - 1) {
                let category = Category(context: self.context)
                category.mainLabel = firstLaunchCategories[count].mainLabel
                category.doCalendar = firstLaunchCategories[count].doCalendar
                category.doTimer = firstLaunchCategories[count].doTimer
                category.iconName = firstLaunchCategories[count].iconName
                category.index = Int64(count)
                categories.append(category)
                saveCategory()
            }
            print("FirstLaunch!")
        }
    }

    private func saveTitleInTempLabel(title: String?) {
        guard let labelTitle = title else { return }
        if !labelTitle.isEmpty {
            self.tempLabel["title"] = labelTitle
        } else {
            print("Be Empty!")
        }
    }

    private func resetTempLabel() {
        self.tempLabel = ["title": "", "date": "", "time": "", "cellIndexPath": IndexPath()]
    }

    private func addLabelToCategory(At indexPath: IndexPath) {
        guard let labelText = self.labelTextField.text else { return }
        print("AddLabelToCategory INIT")
        let label = Label(context: self.context)
        label.title = self.tempLabel["title"] as? String
        label.date = self.tempLabel["date"] as? String
        label.time = self.tempLabel["time"] as? String
        label.done = false
        guard let labelIndex = categories[indexPath.row].labels?.count else { return }
        label.index = Int64(labelIndex)
        label.parentCategory = categories[indexPath.row]
        self.labels.append(label)
        print(labelText)
        saveCategory()
        resetTempLabel()
    }

    private func removeCategory(indexPath: IndexPath) {
        let row = indexPath.row
        context.delete(self.categories[row])
        if row == (self.categories.count - 1) {
            self.categories.remove(at: row)
        } else {
            self.categories.remove(at: row)
            for index in (row)...(categories.count - 1) {
                categories[index].index -= Int64(1)
            }
        }
        for (_, element) in categories.enumerated() {
            print("\(String(describing: element.mainLabel)), \(element.index)")
        }
        saveCategory()
    }


    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let sort = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sort]
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading labels \(error)")
        }
        collectionView.reloadData()
    }

    private func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error saving Label \(error)")
        }
        collectionView.reloadData()
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        self.currentMode = (self.currentMode == .normal) ? .edit : .normal
        currentModeDelegate?.changeEditButtonTitle(currentMode: currentMode)
        collectionView.reloadData()
    }

    deinit {
        print("CategoryVC Deinit")
    }
}

extension CategoryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.alpha = 0
            textField.placeholder = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            textField.backgroundColor = nil
            textField.alpha = 1
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.backgroundColor = nil
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("DidEndEditing")
        guard let text = textField.text else { return }
        if text == "" {
            textField.alpha = 0
            textField.backgroundColor = Color.cellBackgroundColor
            UIView.animate(withDuration: 0.3) {
                textField.alpha = 1
                textField.placeholder = "떠오른 생각을 적어주세요"
            }
        }
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maximumCellCount = 6
        if categories.count == maximumCellCount {
            return categories.count
        } else {
            return (categories.count + 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.categoryViewCell, for: indexPath) as! CategoryViewCell
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.addCategoryViewCell, for: indexPath) as! AddCategoryViewCell
        if indexPath.row == categories.count {
            addCell.delegate = self

            return addCell
        } else {
            categoryCell.delegate = self
            categoryCell.mainLabel.text = categories[indexPath.row].mainLabel
            if let numberOfLabel = categories[indexPath.row].labels?.count {
                categoryCell.numberOfLabel.text = "\(numberOfLabel) 개"
            }
            categoryCell.iconButton.setImage(UIImage(systemName: categories[indexPath.row].iconName!), for: .normal)
            categoryCell.calendarButton.isHidden = false
            categoryCell.timerButton.isHidden = false
            if let icon = categories[indexPath.row].iconName {
                if icon.isEmpty {
                    categoryCell.iconButton.setImage(UIImage(), for: .normal)
                } else {
                    categoryCell.iconButton.setImage(UIImage(systemName: icon), for: .normal)
                }
            }
            if (categories[indexPath.row].doCalendar == true) && (categories[indexPath.row].doTimer == true) {
                categoryCell.calendarButton.tintColor = Color.mainTextColor
                categoryCell.timerButton.tintColor = Color.mainTextColor
            } else if (categories[indexPath.row].doCalendar == true) && (categories[indexPath.row].doTimer == false) {
                categoryCell.calendarButton.tintColor = Color.mainTextColor
                categoryCell.timerButton.isHidden = true
            } else if (categories[indexPath.row].doCalendar == false) && (categories[indexPath.row].doTimer == true) {
                categoryCell.calendarButton.isHidden = true
                categoryCell.timerButton.tintColor = Color.mainTextColor
            } else {
                categoryCell.calendarButton.isHidden = true
                categoryCell.timerButton.isHidden = true
            }
            categoryCell.xButton.isHidden = (self.currentMode == .normal) ? true : false
            if self.currentMode == .edit {
                categoryCell.calendarButton.isHidden = true
                categoryCell.timerButton.isHidden = true
            }

            return categoryCell
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !keyboardIsPresented {
            switch currentMode {
            case .normal:
                performSegue(withIdentifier: "goToLabeled", sender: self)
            case .edit:
                guard let addCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.addCategoryViewController) as? AddCategoryViewController else { return }
                addCategoryVC.isForEdit = true
                addCategoryVC.categoryForEdit = categories[indexPath.row]
                addCategoryVC.delegate = self
                self.present(addCategoryVC, animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLabeled" {
            guard let destinactionVC = segue.destination as? LabelTableViewController else { return }
            guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
            if let indexPath = indexPaths.first {
                destinactionVC.selectedCategory = self.categories[indexPath.row]
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {

        return collectionView.cellForItem(at: indexPath) is CategoryViewCell
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemMove = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(itemMove, at: destinationIndexPath.row)

        for (index, element) in categories.enumerated() {
            element.index = Int64(index)
        }
        print("save Category")
        saveCategory()
    }

    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath, atCurrentIndexPath currentIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        let addCategoryCellIndexPathRow = categories.count
        if proposedIndexPath.row == addCategoryCellIndexPathRow {

            return originalIndexPath
        } else {

            return proposedIndexPath
        }
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = self.collectionView.bounds.size
        let cellWidth = (bounds.width - 10) / 2
        let cellHeight = (bounds.height - 20) / 3

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return CGFloat(10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return CGFloat(10)
    }
}

extension CategoryViewController: CategoryViewControllerDelegate {
    func changeEditButtonTitle(currentMode: CurrentMode) {
        self.editButton.title = (currentMode == .edit) ? "완료" : "편집"
    }

    func removeCategoryCell(cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        guard let numberOfLabelInCategory = categories[indexPath.row].labels?.count else { return }

        let alert = UIAlertController(title: "❗️해당 카테고리에 라벨이 들어있습니다. 그래도 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let targetCategory = self?.categories[indexPath.row] else { return }
            self?.context.delete(targetCategory)
            if indexPath.row == ((self?.categories.count)! - 1) {
                self?.categories.remove(at: indexPath.row)
            } else {
                self?.categories.remove(at: indexPath.row)
                for index in (indexPath.row)...((self?.categories.count)! - 1) {
                    self?.categories[index].index -= Int64(1)
                }
            }
            self?.saveCategory()
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)

        if numberOfLabelInCategory == 0 {
            let row = indexPath.row
            self.context.delete((categories[row]))
            if row == ((categories.count) - 1) {
                categories.remove(at: row)
            } else {
                categories.remove(at: row)
                for index in (row)...((categories.count) - 1) {
                    categories[index].index -= Int64(1)
                }
            }
            saveCategory()
        } else {
            self.present(alert, animated: true)
        }
    }
}

extension CategoryViewController: AddSelectedDateTimeDelegate {
    func presentAddCategoryController() {
        guard let addCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: Identifier.addCategoryViewController) as? AddCategoryViewController else { return }
        addCategoryVC.delegate = self
        self.present(addCategoryVC, animated: true)
    }

    func addCategory(mainLabel: String, doCalendar: Bool, doTimer: Bool, iconName: String) {
        let newCategory = Category(context: self.context)
        newCategory.mainLabel = mainLabel
        newCategory.doCalendar = doCalendar
        newCategory.doTimer = doTimer
        newCategory.iconName = iconName
        newCategory.index = Int64(categories.count)
        categories.append(newCategory)
        for (_, element) in categories.enumerated() {
            print("\(String(describing: element.mainLabel)), \(element.index)")
        }
        saveCategory()
    }

    func modifyCategory(mainLabel: String, iconName: String, index: Int64) {
        let targetIndex: Int = Int(index)
        categories[targetIndex].mainLabel = mainLabel
        categories[targetIndex].iconName = iconName
        saveCategory()
    }
}
