import Foundation
import UIKit

protocol CategoryViewControllerDelegate {
    func changeEditButtonTitle(currentMode: CurrentMode)
    func removeCategoryCell(cell: UICollectionViewCell)
}

protocol AddSelectedProperty {
    func presentAddCategoryController()
    func addCategory(mainLabel: String, subLabel: String, doCalendar: Bool, doTimer: Bool, iconName: String)
    func modifyCategory(mainLabel: String, subLabel: String, iconName: String, index: Int64)
}
