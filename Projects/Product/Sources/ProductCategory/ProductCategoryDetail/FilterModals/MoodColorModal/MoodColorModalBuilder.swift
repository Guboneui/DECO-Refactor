//
//  MoodColorModalBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs

protocol MoodColorModalDependency: Dependency {
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream { get }
}

final class MoodColorModalComponent: Component<MoodColorModalDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MoodColorModalBuildable: Buildable {
    func build(withListener listener: MoodColorModalListener) -> MoodColorModalRouting
}

final class MoodColorModalBuilder: Builder<MoodColorModalDependency>, MoodColorModalBuildable {

    override init(dependency: MoodColorModalDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MoodColorModalListener) -> MoodColorModalRouting {
        let component = MoodColorModalComponent(dependency: dependency)
        let viewController = MoodColorModalViewController()
        let interactor = MoodColorModalInteractor(
          presenter: viewController,
          selectedFilterInProductCategory: dependency.selectedFilterInProductCategory
        )
        interactor.listener = listener
        return MoodColorModalRouter(interactor: interactor, viewController: viewController)
    }
}
