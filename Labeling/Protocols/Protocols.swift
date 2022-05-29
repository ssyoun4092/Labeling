import Foundation
import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func changeEditButtonTitle(currentMode: CurrentMode)
    func removeCategoryCell(cell: UICollectionViewCell)
}

protocol AddSelectedDateTimeDelegate: AnyObject {
    func presentAddCategoryController()
    func addCategory(mainLabel: String, subLabel: String, doCalendar: Bool, doTimer: Bool, iconName: String)
    func modifyCategory(mainLabel: String, subLabel: String, iconName: String, index: Int64)
}

protocol PassingIconDelegate: AnyObject {
    func passSelectedIcon(name: String)
}
