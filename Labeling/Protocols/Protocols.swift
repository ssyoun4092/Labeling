import Foundation
import UIKit

protocol CategoryViewControllerDelegate {
    func changeEditButtonTitle(currentMode: CurrentMode)
    func removeCategoryCell(cell: UICollectionViewCell)
}

protocol AddSelectedProperty {
    func presentAddCategoryController()
    func addCategory(mainLabel: String, subLabel: String, doCalendar: Bool, doTimer: Bool)
    func addSelectedDateToLabel(date: String)
    func saveSelectedDateToLabel(date: String, indexPath: IndexPath?)
    func saveSelectedTimeToLabel(time: String, indexPath: IndexPath?)
}