import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!

    let textArray = ["1", "2", "3", "4", "5", "6", "7"]
    lazy var textFieldOriginX = textField.frame.origin.x
    lazy var textFieldOriginY = textField.frame.origin.y
    var cellRectArray: [[Double]] = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        initCollectionView()
        setUpTextField()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        print("Screen Width: \(UIScreen.main.bounds.width), Screen Height: \(UIScreen.main.bounds.height)")
        print("CollectionView CGSize: \(collectionView.bounds.size)")
    }

    func setUpCollectionView() {
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.layer.shadowColor = CGColor(gray: 1, alpha: 0.5)
        self.collectionView.layer.shadowOffset = CGSize(width: 100, height: 100)
        self.collectionView.layer.backgroundColor = UIColor.blue.cgColor
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
        let transition = gesture.translation(in: self.textField)
        let label = gesture.view!

        label.center = CGPoint(x: label.center.x + transition.x, y: label.center.y + transition.y)
        switch gesture.state {
        case .began:
            print(self.cellRectArray)
        case .changed :
            animateIn()
            print("label.center.x: \(label.center.x), label.center.y: \(label.center.y)")
            showCellOnGesture(currentGesturePoint: label.center)
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
            self.hideBottomLine()
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
            disableCellShow(index: 0)
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y1Point && point.y <= y2Point {
            disableCellShow(index: 1)
        } else if point.x >= x1Point && point.x <= x2Point && point.y >= y3Point && point.y <= y4Point {
            disableCellShow(index: 2)
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y3Point && point.y <= y4Point {
            disableCellShow(index: 3)
        } else if point.x >= x1Point && point.x <= x2Point && point.y >= y5Point && point.y <= y6Point {
            disableCellShow(index: 4)
        } else if point.x >= x3Point && point.x <= x4Point && point.y >= y5Point && point.y <= y6Point {
            disableCellShow(index: 5)
        }

        func disableCellShow(index: Int) {
            collectionView.cellForItem(at: IndexPath(row: index, section: 0))?.backgroundColor = .cyan
            if index > 0 && index < 5 {
                for i in 0..<index {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
                for i in (index+1)...5 {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
            } else if index == 0 {
                for i in (index+1)...5 {
                    collectionView.cellForItem(at: IndexPath(row: i, section: 0))?.backgroundColor = .gray
                }
            } else {
                for i in 0..<index {
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
        UIView.animate(withDuration: 0.3) {
            self.textField.frame.origin.x = self.textFieldOriginX
            self.textField.frame.origin.y = self.textFieldOriginY
            self.textField.transform = CGAffineTransform.identity
            self.showBottomLine()
        }
    }

    func hideBottomLine() {
        let subViews = self.textField.subviews
        for subView in subViews {
            if subView.tag == 100 {
                subView.alpha = 0
            }
        }
    }

    func showBottomLine() {
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

        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = attributes?.frame
        let cellFrameInSuperview = collectionView.convert(cellRect ?? CGRect.zero, to: collectionView.superview)
        print(cellFrameInSuperview)
//        cellRectArray = convertCGRectToArray(tuple: cellArray)

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

        print("cell Width: \(cellWidth), cell height: \(cellHeight)")

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
