import Foundation
import CoreData
import RxSwift

protocol CategoryFetchable {
    func loadCategoriesFirstAppLaunch() -> Observable<[Category]>
    func loadCategories() -> Observable<[Category]>
}

class CategoryStore: CategoryFetchable {
    let firstCategories: [FirstLaunchCategory] = FirstLaunchCategory.categories
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func loadCategoriesFirstAppLaunch() -> Observable<[Category]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            var categories = [Category]()

            for count in 0...(self.firstCategories.count - 1) {
                let category = Category(context: self.context)
                category.mainLabel = self.firstCategories[count].mainLabel
                category.doCalendar = self.firstCategories[count].doCalendar
                category.doTimer = self.firstCategories[count].doTimer
                category.iconName = self.firstCategories[count].iconName
                category.index = Int64(count)
                categories.append(category)
                self.saveCategory()
            }

            return Disposables.create()
        }
    }

    func loadCategories() -> Observable<[Category]> {
        return Observable.create { [weak self] observer in
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            let sort = NSSortDescriptor(key: "index", ascending: true)
            request.sortDescriptors = [sort]
            do {
                let categories = try self?.context.fetch(request)
                observer.onNext(categories ?? [])
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    private func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error saving Label \(error)")
        }
    }
}
