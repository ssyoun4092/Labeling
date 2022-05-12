//
//  ViewController.swift
//  Labeling
//
//  Created by MacPro on 2022/04/27.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let textArray = ["1", "2", "3", "4", "5", "6", "7"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let dragInteraction = UIDragInteraction(delegate: self)
//        self.textField.isUserInteractionEnabled = true
//        self.textField.addInteraction(dragInteraction)
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
//        self.label.isUserInteractionEnabled = true
//        self.label.addInteraction(dragInteraction)
//        self.textField.addGestureRecognizer(gesture)
        setUpCollectionView()
        setCellsView()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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

//    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
//        let transition = gesture.translation(in: self.label)
//        let label = gesture.view!
//
//        label.center = CGPoint(x: label.center.x + transition.x, y: label.center.y + transition.y)
//        gesture.setTranslation(.zero, in: self.label)
//    }

//    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
//        let textField = self.textField
//        let provider = NSItemProvider(object: textField! as! NSItemProviderWriting)
//        let item = UIDragItem(itemProvider: provider)
//        return [item]
//    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collector", for: indexPath) as! CollectorCell
//        cell.backgroundColor = UIColor.red
//        cell.cellLabel.text = self.textArray[indexPath.row]
//        cell.cellLabel.textColor = .white

        return cell
    }
}
