import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol CategoryViewModelType {
    var loadCategories: AnyObserver<Void> { get }
    var tapEditButton: AnyObserver<Void> { get }

    var allCategories: Observable<[CategoryMenu]> { get }
    var currentMode: Observable<EditMode> { get }
}

class CategoryViewModel: CategoryViewModelType {
    let disposeBag = DisposeBag()

    let loadCategories: AnyObserver<Void>
    let tapEditButton: AnyObserver<Void>

    let allCategories: Observable<[CategoryMenu]>
    let currentMode: Observable<EditMode>

    init(domain: CategoryFetchable = CategoryStore()) {
        let loading = PublishSubject<Void>()
        let categories = BehaviorSubject<[CategoryMenu]>(value: [])
        let switchingMode = PublishSubject<Void>()
        let switchedMode = BehaviorSubject<EditMode>(value: .normal)

        loadCategories = loading.asObserver()

        loading
            .flatMap { _ in
                UIApplication.isFirstLaunch()
                ? domain.loadCategoriesFirstAppLaunch()
                : domain.loadCategories()
            }
            .map { $0.map { CategoryMenu($0, mode: .normal) } }
            .subscribe(onNext: categories.onNext)
            .disposed(by: disposeBag)

        allCategories = categories

        tapEditButton = switchingMode.asObserver()

        currentMode = switchingMode.withLatestFrom(switchedMode)
            .map { mode -> EditMode in
                if mode == .normal {
                    return .edit
                } else {
                    return .normal
                }
            }
            .do(onNext: {
                print($0)
            })
    }   
}
