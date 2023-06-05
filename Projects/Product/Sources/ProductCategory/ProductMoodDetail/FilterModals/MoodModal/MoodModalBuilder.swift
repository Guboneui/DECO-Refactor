//
//  MoodModalBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import RIBs

protocol MoodModalDependency: Dependency {
  var selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream { get }
}

final class MoodModalComponent: Component<MoodModalDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MoodModalBuildable: Buildable {
    func build(withListener listener: MoodModalListener) -> MoodModalRouting
}

final class MoodModalBuilder: Builder<MoodModalDependency>, MoodModalBuildable {

    override init(dependency: MoodModalDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MoodModalListener) -> MoodModalRouting {
        let component = MoodModalComponent(dependency: dependency)
        let viewController = MoodModalViewController()
        let interactor = MoodModalInteractor(
          presenter: viewController,
          selectedFilterInProductMood: dependency.selectedFilterInProductMood
        )
        interactor.listener = listener
        return MoodModalRouter(interactor: interactor, viewController: viewController)
    }
}
