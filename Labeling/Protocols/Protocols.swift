import Foundation
import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func changeEditButtonTitle(currentMode: CurrentMode)
    func removeCategoryCell(cell: UICollectionViewCell)
}

protocol AddCategoryDelegate {
    func showAddCategoryController()
    func addCategory(mainLabel: String, subLabel: String, doCalendar: Bool, doTimer: Bool)
}
