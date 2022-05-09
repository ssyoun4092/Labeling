import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!

    let textArray = ["1", "2", "3", "4", "5", "6", "7"]
    lazy var textFieldOrigin = textField.frame.origin
    var cellRectArray: [[Double]] = [[]]
    var isTaskOnCell: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        initCollectionView()
        setUpTextField()
        print("viewDidLoad: \(self.textFieldOrigin)")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    func setUpCollectionView() {
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.layer.shadowColor = CGColor(gray: 1, alpha: 0.5)
        self.collectionView.layer.shadowOffset = CGSize(width: 100, height: 100)
    }

    func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.register(UINib(nibName: "CollectorViewCell", bundle: nil), forCellWithReuseIdentifier: CollectorViewCell.identifier)
    }

    func setUpTextField() {
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
        self.textField.isUserInteractionEnabled = true
        self.textField.addGestureRecognizer(dragGesture)
        self.textField.addBottomLineView(width: 1)
    }

    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.textField.superview)
        let changedXPoint = self.textField.center.x + translation.x
        let changedYPoint = self.textField.center.y + translation.y
        switch gesture.state {
        case .began:
            animateIn()
        case .changed :
            self.textField.center = CGPoint(x: changedXPoint, y: changedYPoint)
            showCellOnGesture(currentGesturePoint: self.textField.center)
        case .ended :
            disableAllCellShow()
            animateOut()
        default:
            break
        }
        gesture.setTranslation(.zero, in: self.textField)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    func animateIn() {
        UIView.animate(withDuration: 0.1) {
            self.hideTextFieldBottomLine()
            self.textField.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
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
                self.textField.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.3) {
                    self.textField.frame.origin = self.textFieldOrigin
                    self.textField.transform = CGAffineTransform.identity
                    self.showTextFieldBottomLine()
                }
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                print(self.textFieldOrigin)
                print(self.textField.frame.origin)
                self.textField.frame.origin = self.textFieldOrigin
                print(self.textFieldOrigin)
                print(self.textField.frame.origin)
                print("-------------------------")
                self.textField.transform = CGAffineTransform.identity
                self.showTextFieldBottomLine()
                
            }
        }
    }

    func hideTextFieldBottomLine() {
        let subViews = self.textField.subviews
        for subView in subViews {
            if subView.tag == 100 {
                subView.alpha = 0
            }
        }
    }

    func showTextFieldBottomLine() {
        let subViews = self.textField.subviews
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectorViewCell.identifier, for: indexPath) as! CollectorViewCell
        cell.mainLabel.text = textArray[indexPath.row]
        cell.subLabel.text = "hey"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectorViewCell {
            print("Tapped!")
            cell.showViewColor()
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
struct AddTaskViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
            .preferredColorScheme(.light)
    }
}
#endif
