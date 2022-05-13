import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var taskTextField: UITextField!
    lazy var textFieldOrigin = taskTextField.frame.origin
    var isTaskOnCell: Bool = false
    var keyboardIsPresented: Bool = false

    let trashLabel = LabelCell(mainLabel: "휴지통", subLabel: "필요없는 생각은 저한테 주세요")
    let somedayLabel = LabelCell(mainLabel: "언젠가", subLabel: "나중에 찾아볼 것 같을때 저한테 주세요")
    let referenceLabel = LabelCell(mainLabel: "참고자료", subLabel: "필요할 때 찾아볼 것 같을때 저한테 주세요")
    let delegateLabel = LabelCell(mainLabel: "위임", subLabel: "다른 누군가에게 맡겨야할 때 저한테 주세요")
    let calendarLabel = LabelCell(mainLabel: "일정표", subLabel: "특정 시기에 실행해야할 때")
    let asapLabel = LabelCell(mainLabel: "가능한 빨리", subLabel: "최대한 빨리 해야할 때")
    lazy var labelCell: [LabelCell] = [trashLabel, somedayLabel, referenceLabel, delegateLabel, calendarLabel, asapLabel]

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    func setUpTaskTextField() {
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
        self.taskTextField.delegate = self
        self.taskTextField.isUserInteractionEnabled = true
        self.taskTextField.addGestureRecognizer(dragGesture)
        self.taskTextField.center = self.view.center
        guard let placeHolderWidth = taskTextField.attributedPlaceholder?.size().width else { return }
        self.taskTextField.addBottomLineView(width: placeHolderWidth, height: 1)
    }

    @objc func keyboardDidShow() {
        print("keyboardWillShow")
        self.keyboardIsPresented = true
        print(keyboardIsPresented)
    }

    @objc func keyboardDidHide() {
        print("keyboardWillHide")
        self.keyboardIsPresented = false
        print(keyboardIsPresented)
    }
    
    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.taskTextField.superview)
        let changedXPoint = self.taskTextField.center.x + translation.x
        let changedYPoint = self.taskTextField.center.y + translation.y
        switch gesture.state {
        case .began:
            animateIn()
        case .changed :
            self.taskTextField.center = CGPoint(x: changedXPoint, y: changedYPoint)
            showCellOnGesture(currentGesturePoint: self.taskTextField.center)
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
    
    func animateIn() {
        UIView.animate(withDuration: 0.1) {
            self.hideTextFieldBottomLine()
            self.taskTextField.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    func showCellOnGesture(currentGesturePoint point: CGPoint) {
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
            disableCellShowExcept(index: 0)
            self.isTaskOnCell = true
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
            disableCellShowExcept(index: 1)
            self.isTaskOnCell = true
        } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
            disableCellShowExcept(index: 2)
            self.isTaskOnCell = true
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y3Point && point.y <= y4Point {
            disableCellShowExcept(index: 3)
            self.isTaskOnCell = true
        } else if point.x >= x1Point && point.x <= x2Point && point.y >= y5Point && point.y <= y6Point {
            disableCellShowExcept(index: 4)
            self.isTaskOnCell = true
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y5Point && point.y <= y6Point {
            disableCellShowExcept(index: 5)
            self.isTaskOnCell = true
        } else {
            disableAllCellShow()
            self.isTaskOnCell = false
        }
        
        func disableCellShowExcept(index: Int = 6) {
            collectionView.cellForItem(at: IndexPath(row: index, section: 0))?.backgroundColor = .cyan
            if index > 0 && index < 5 {
                for i in 0..<index {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
                for i in (index + 1)...5 {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
            } else if index == 0 {
                for i in (index + 1)...5 {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
            } else if index == 5{
                for i in 0..<(index - 1) {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
            } else {
                for i in 0...(index - 1) {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
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
                UIView.animate(withDuration: 0.3) {
                    self.taskTextField.frame.origin = self.textFieldOrigin
                    self.taskTextField.transform = CGAffineTransform.identity
                    self.showTextFieldBottomLine()
                }
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.taskTextField.frame.origin = self.textFieldOrigin
                self.taskTextField.transform = CGAffineTransform.identity
                self.showTextFieldBottomLine()
                
            }
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
    
    func convertCGRectToArray(tuple: [(Double, Double, Double, Double)]) -> [[Double]] {
        let arrayCount = tuple.count
        var returnArray: [[Double]] = [[]]
        for index in 0...(arrayCount-1) {
            let array = Mirror(reflecting: tuple[index]).children.map({ $0.value}) as! [Double]
            returnArray.append(array)
        }
        returnArray.remove(at: 0)
        
        return returnArray
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let length = textField.attributedText?.size().width else { return }
        removeTextFieldBottomLine()
        textField.addBottomLineView(width: length, height: 1)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectorViewCell.identifier, for: indexPath) as! CollectorViewCell
        cell.mainLabel.text = labelCell[indexPath.row].mainLabel
        cell.subLabel.text = labelCell[indexPath.row].subLabel
        
        return cell
    }
    
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
