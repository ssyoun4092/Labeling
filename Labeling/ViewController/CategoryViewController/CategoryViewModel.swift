import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol CategoryViewModelType {
    var loadCategories: AnyObserver<Void> { get }
    var allCategories: Observable<[CategoryMenu]> { get }
}

class CategoryViewModel: CategoryViewModelType {
    let disposeBag = DisposeBag()

    let loadCategories: AnyObserver<Void>
    let allCategories: Observable<[CategoryMenu]>

    init(domain: CategoryFetchable = CategoryStore()) {
        let loading = PublishSubject<Void>()
        let categories = BehaviorSubject<[CategoryMenu]>(value: [])

        loadCategories = loading.asObserver()

        loading
            .flatMap { _ in
                UIApplication.isFirstLaunch()
                ? domain.loadCategoriesFirstAppLaunch()
                : domain.loadCategories()
            }
            .map { $0.map { CategoryMenu($0) } }
            .subscribe(onNext: categories.onNext)
            .disposed(by: disposeBag)


        allCategories = categories
    }   
}
