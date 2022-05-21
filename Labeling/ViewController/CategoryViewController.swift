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
    var currentModeDelegate: CategoryViewControllerDelegate?
    var currentMode: CurrentMode = .normal
    var categories = [Category]()
    lazy var firstLaunchCategories: [FirstLaunchCategory] = [trashLabel, somedayLabel, referenceLabel, delegateLabel, calendarLabel, asapLabel]
    var labels = [Label]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        initCollectionView()
        setUpCollectionView()
        setUpLabelTextField()
        loadCategoriesFirstAppLaunch()
        loadCategories()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        self.collectionView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellWithReuseIdentifier: CategoryViewCell.identifier)
        self.collectionView.register(UINib(nibName: "AddCategoryViewCell", bundle: nil), forCellWithReuseIdentifier: AddCategoryViewCell.identifier)
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
        guard let placeHolderWidth = labelTextField.attributedPlaceholder?.size().width else { return }
        self.labelTextField.addBottomLineView(width: placeHolderWidth, height: 1)
    }

    //MARK: - Gesture functions
    @objc func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.labelTextField.superview)
        let changedXPoint = self.labelTextField.center.x + translation.x
        let changedYPoint = self.labelTextField.center.y + translation.y
        switch gesture.state {
        case .began:
            animateHideTextFieldBottomLine()
            self.view.endEditing(true)
        case .changed :
            self.labelTextField.center = CGPoint(x: changedXPoint, y: changedYPoint)
            let indexPath = calculateCellIndexPath(on: self.labelTextField.center)
            disableCellColorExceptAt(indexPath: indexPath)
            isGestureOnCellAt(indexPath: indexPath)
        case .ended :
            print("================")
            let indexPath = calculateCellIndexPath(on: self.labelTextField.center)
            disableAllCellColor()
            animateOut()
            if !(indexPath.row == 6) {
                addLabelToCategory(indexPath: indexPath)
            }
        default:
            break
        }
        gesture.setTranslation(.zero, in: self.labelTextField)
    }

    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if currentMode == .edit {
            guard let collectionView = collectionView else { return }
            switch gesture.state {
            case .began:
                guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            case .ended:
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
        }
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

    private func isGestureOnCellAt(indexPath: IndexPath) {
        if indexPath.row == 6 {
            self.isLabelOnCell = false
        } else {
            self.isLabelOnCell = true
        }
    }

    private func disableCellColorExceptAt(indexPath: IndexPath) {
        let row = indexPath.row
        collectionView.cellForItem(at: IndexPath(row: row, section: 0))?.backgroundColor = .cyan
        if row > 0 && row < 5 {
            for i in 0..<row {
                collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
            }
            for i in (row + 1)...5 {
                collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
            }
        } else if row == 0 {
            for i in (row + 1)...5 {
                collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
            }
        } else if row == 5{
            for i in 0..<(row - 1) {
                collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
            }
        } else {
            for i in 0...(row - 1) {
                collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
            }
        }
    }

    private func disableAllCellColor() {
        for index in 0...5 {
            collectionView.cellForItem(at: IndexPath(row: index, section: 0))?.backgroundColor = .gray
        }
    }
    
    private func animateOut() {
        if isLabelOnCell {
            UIView.animate(withDuration: 0.3) {
                self.labelTextField.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.labelTextField.animateDisappearAndAppearAt(
                    initialOrigin: self.textFieldOrigin,
                    duration: 0.3,
                    bottomLineAction: self.showTextFieldBottomLine()
                )
            }
        } else {
            self.labelTextField.animateDisappearAndAppearAt(
                initialOrigin: self.textFieldOrigin,
                duration: 0.3,
                bottomLineAction: self.showTextFieldBottomLine()
            )
        }
    }

    //MARK: - Handling Coredata
    private func loadCategoriesFirstAppLaunch() {
        if UIApplication.isFirstLaunch() {
            for count in 0...(firstLaunchCategories.count - 1) {
                let category = Category(context: self.context)
                category.mainLabel = firstLaunchCategories[count].mainLabel
                category.subLabel = firstLaunchCategories[count].subLabel
                category.doCalendar = firstLaunchCategories[count].doCalendar
                category.doTimer = firstLaunchCategories[count].doTimer
                category.index = Int64(count)
                categories.append(category)
                saveCategory()
            }
            print("FirstLaunch!")
        }
    }

    private func addLabelToCategory(indexPath: IndexPath) {
        guard let labelText = self.labelTextField.text else { return }
        if !labelText.isEmpty {
            let label = Label(context: self.context)
            label.title = labelText
            label.done = false
            guard let labelIndex = categories[indexPath.row].labels?.count else { return }
            label.index = Int64(labelIndex)
            label.parentCategory = categories[indexPath.row]
            self.labels.append(label)
            print(labelText)
            saveCategory()
        } else {
            print("labelText is Empty")
        }
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
            print("LoadCategories")
        } catch {
            print("Error loading labels \(error)")
        }
        collectionView.reloadData()
    }

    private func saveCategory() {
        do {
            try context.save()
            print("Sucess Save")
        } catch {
            print("error saving Label \(error)")
            print("Nothing Happen")
        }
        collectionView.reloadData()
    }

    //MARK: - Handling TextField BottomLine
    private func animateHideTextFieldBottomLine() {
        UIView.animate(withDuration: 0.3) {
            self.hideTextFieldBottomLine()
            self.labelTextField.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }

    private func showTextFieldBottomLine() {
        let subViews = self.labelTextField.subviews
        for subView in subViews {
            if subView.tag == 100 {
                subView.alpha = 1
            }
        }
    }

    private func hideTextFieldBottomLine() {
        let subViews = self.labelTextField.subviews
        for subView in subViews {
            if subView.tag == 100 {
                subView.alpha = 0
            }
        }
    }

    private func removeTextFieldBottomLine() {
        let subviews = self.labelTextField.subviews
        for subview in subviews {
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        self.currentMode = (self.currentMode == .normal) ? .edit : .normal
        currentModeDelegate?.changeEditButtonTitle(currentMode: currentMode)
        collectionView.reloadData()
    }
}

//MARK: - ViewController Extensions
extension CategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let length = textField.attributedText?.size().width else { return }
        removeTextFieldBottomLine()
        textField.addBottomLineView(width: length, height: 1)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categories.count == 6 {
            return categories.count
        } else {
            return (categories.count + 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCategoryViewCell.identifier, for: indexPath) as! AddCategoryViewCell
        if indexPath.row == categories.count {
            addCell.delegate = self

            return addCell
        } else {
            categoryCell.delegate = self
            categoryCell.mainLabel.text = categories[indexPath.row].mainLabel
            categoryCell.subLabel.text = categories[indexPath.row].subLabel
            categoryCell.calendarButton.tintColor = (categories[indexPath.row].doCalendar == true) ? .purple : .gray
            categoryCell.timerButton.tintColor = (categories[indexPath.row].doTimer == true) ? .purple : .gray
            categoryCell.xButton.isHidden = (self.currentMode == .normal) ? true : false

            return categoryCell
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !keyboardIsPresented {
            performSegue(withIdentifier: "goToLabeled", sender: self)
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

        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemMove = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(itemMove, at: destinationIndexPath.row)

        for (index, element) in categories.enumerated() {
            element.index = Int64(index)
        }
        saveCategory()
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
}

extension CategoryViewController: AddCategoryDelegate {

    func showAddCategoryController() {
//        guard let addCategoryViewController = self.storyboard?.instantiateViewController(withIdentifier: AddCategoryViewController.identifier) as? AddCategoryViewController else { return }
        guard let addCategoryViewController = self.storyboard?.instantiateViewController(withIdentifier: SelectDateViewController.identifier) as? SelectDateViewController else { return }
//        addCategoryViewController.delegate = self
        addCategoryViewController.modalPresentationStyle = .overCurrentContext
        addCategoryViewController.modalTransitionStyle = .crossDissolve
        self.present(addCategoryViewController, animated: true)
    }

    func addCategory(mainLabel: String, subLabel: String, doCalendar: Bool, doTimer: Bool) {
        let newCategory = Category(context: self.context)
        newCategory.mainLabel = mainLabel
        newCategory.subLabel = subLabel
        newCategory.doCalendar = doCalendar
        newCategory.doTimer = doTimer
        newCategory.index = Int64(categories.count)
        categories.append(newCategory)
        for (_, element) in categories.enumerated() {
            print("\(String(describing: element.mainLabel)), \(element.index)")
        }
        saveCategory()
    }
}

//MARK: - SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct CategoryViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = CategoryViewController

    func makeUIViewController(context: Context) -> CategoryViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! CategoryViewController
    }

    func updateUIViewController(_ uiViewController: CategoryViewController, context: Context) {

    }
}

struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CategoryViewControllerRepresentable()
            .preferredColorScheme(.light)
    }
}
#endif
