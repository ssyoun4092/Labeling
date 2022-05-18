import Foundation
import CoreData


extension Label {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Label> {
        return NSFetchRequest<Label>(entityName: "Label")
    }

    @NSManaged public var done: Bool
    @NSManaged public var index: Int64
    @NSManaged public var title: String?
    @NSManaged public var parentCategory: Category?

}

extension Label : Identifiable {

}
