import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taskTextField: UITextField!
    var textFieldOrigin: CGPoint = CGPoint()
    var selectedCell: UICollectionViewCell? = nil
    var isTaskOnCell: Bool = false
    var keyboardIsPresented: Bool = false
    
    lazy var labelCell: [LabelCell] = [trashLabel, somedayLabel, referenceLabel, delegateLabel, calendarLabel, asapLabel]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        setUpCollectionView()
        initCollectionView()
        setUpTaskTextField()
        print("viewDidLoad: \(self.textFieldOrigin)")
        let tapForDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapForDismissKeyboard.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapForDismissKeyboard)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpCollectionView() {
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.layer.shadowColor = CGColor(gray: 1, alpha: 0.5)
        self.collectionView.layer.shadowOffset = CGSize(width: 100, height: 100)
    }
    
    func setCellsView() {
        let width = (collectionView.frame.size.width) / 3
        let height = (collectionView.frame.size.height * 0.6) / 6
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.register(UINib(nibName: "CollectorViewCell", bundle: nil), forCellWithReuseIdentifier: CollectorViewCell.identifier)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }

    func setUpTaskTextField() {
        textFieldOrigin = self.taskTextField.frame.origin
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragGestrue))
        self.taskTextField.delegate = self
        self.taskTextField.isUserInteractionEnabled = true
        self.taskTextField.addGestureRecognizer(dragGesture)
        guard let placeHolderWidth = taskTextField.attributedPlaceholder?.size().width else { return }
        self.taskTextField.addBottomLineView(width: placeHolderWidth, height: 1)
    }

    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            print(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    @objc func keyboardDidShow() {
        self.keyboardIsPresented = true
    }

    @objc func keyboardDidHide() {
        self.keyboardIsPresented = false
    }
    
    @objc func handleDragGestrue(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.taskTextField.superview)
        let changedXPoint = self.taskTextField.center.x + translation.x
        let changedYPoint = self.taskTextField.center.y + translation.y
        switch gesture.state {
        case .began:
            animateHideTextFieldBottomLine()
            self.view.endEditing(true)
        case .changed :
            self.taskTextField.center = CGPoint(x: changedXPoint, y: changedYPoint)
            let indexPath = calculateCellIndexPath(on: self.taskTextField.center)
            disableCellShowExceptAt(indexPath: indexPath)
            doesGestureOnCellAt(indexPath: indexPath)
        case .ended :
            disableAllCellShow()
            animateOut()
        default:
            break
        }
        gesture.setTranslation(.zero, in: self.taskTextField)
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func animateHideTextFieldBottomLine() {
        UIView.animate(withDuration: 0.3) {
            self.hideTextFieldBottomLine()
            self.taskTextField.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }

    func calculateCellIndexPath(on point: CGPoint) -> IndexPath {
        let collectionViewOriginX = collectionView.frame.origin.x
        let collectionViewOriginY = collectionView.frame.origin.y
        let collectionViewWidth = collectionView.frame.size.width
        let collectionViewHeight = collectionView.frame.size.height
        let spacing: CGFloat = 10
        let cellHeight = (collectionViewHeight - (2 * spacing)) / 3

        let x1Point = collectionViewOriginX
        let x2Point = collectionViewOriginX + (collectionViewWidth / 2)
        let x3Point = collectionViewOriginX + (collectionViewWidth / 2) + spacing
        let x4Point = collectionViewOriginX + collectionViewWidth
        let y1Point = collectionViewOriginY
        let y2Point = collectionViewOriginY + cellHeight
        let y3Point = collectionViewOriginY + cellHeight + spacing
        let y4Point = collectionViewOriginY + (2 * cellHeight) + spacing
        let y5Point = collectionViewOriginY + (2 * cellHeight) + (2 * spacing)
        let y6Point = collectionViewOriginY + collectionViewHeight

        if point.x >= x1Point && point.x <= x2Point && point.y >= y1Point && point.y <= y2Point {
            return IndexPath(row: 0, section: 0)
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
            return IndexPath(row: 1, section: 0)
        } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
            return IndexPath(row: 2, section: 0)
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y3Point && point.y <= y4Point {
            return IndexPath(row: 3, section: 0)
        } else if point.x >= x1Point && point.x <= x2Point && point.y >= y5Point && point.y <= y6Point {
            return IndexPath(row: 4, section: 0)
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y5Point && point.y <= y6Point {
            return IndexPath(row: 5, section: 0)
        } else {
            return IndexPath(row: 6, section: 0)
        }
    }

    func doesGestureOnCellAt(indexPath: IndexPath) {
        if indexPath.row == 6 {
            self.isTaskOnCell = false
        } else {
            self.isTaskOnCell = true
        }
    }

    func disableCellShowExceptAt(indexPath: IndexPath) {
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

    func disableAllCellShow() {
        for index in 0...5 {
            collectionView.cellForItem(at: IndexPath(row: index, section: 0))?.backgroundColor = .gray
        }
    }
    
    func animateOut() {
        if isTaskOnCell {
            UIView.animate(withDuration: 0.3) {
                self.taskTextField.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.taskTextField.animateDisappearAndAppearAt(
                    initialOrigin: self.textFieldOrigin,
                    duration: 0.3,
                    bottomLineAction: self.showTextFieldBottomLine()
                )
            }
        } else {
            self.taskTextField.animateDisappearAndAppearAt(
                initialOrigin: self.textFieldOrigin,
                duration: 0.3,
                bottomLineAction: self.showTextFieldBottomLine()
            )
        }
    }

    func removeTextFieldBottomLine() {
        let subviews = self.taskTextField.subviews
        for subview in subviews {
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }
    
    func hideTextFieldBottomLine() {
        let subViews = self.taskTextField.subviews
        for subView in subViews {
            if subView.tag == 100 {
                subView.alpha = 0
            }
        }
    }
    
    func showTextFieldBottomLine() {
        let subViews = self.taskTextField.subviews
        for subView in subViews {
            if subView.tag == 100 {
                subView.alpha = 1
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let length = textField.attributedText?.size().width else { return }
        removeTextFieldBottomLine()
        textField.addBottomLineView(width: length, height: 1)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelCell.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectorViewCell.identifier, for: indexPath) as! CollectorViewCell
        cell.mainLabel.text = labelCell[indexPath.row].mainLabel
        cell.subLabel.text = labelCell[indexPath.row].subLabel
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !keyboardIsPresented {
            //            guard let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "LabeledTableViewController") else { return }
            //            print("Tapped!")
            //            self.navigationController?.pushViewController(tableViewController, animated: true)

            performSegue(withIdentifier: "goToLabeled", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinactionVC = segue.destination as! LabeledTableViewController
        if let indexPath = collectionView.indexPathsForSelectedItems {
            print("\(indexPath)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {

        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var labelCell = self.labelCell
        let label = labelCell[sourceIndexPath.row]
        labelCell.remove(at: sourceIndexPath.row)
        labelCell.insert(label, at: destinationIndexPath.row)
        self.labelCell = labelCell
        print(self.labelCell)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
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

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    func makeUIViewController(context: Context) -> ViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {

    }
}

struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
            .preferredColorScheme(.light)
    }
}
#endif
