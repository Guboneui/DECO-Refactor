//
//  ProfileEditRouter.swift
//  Profile
//
//  Created by 구본의 on 2023/05/28.
//

import RIBs

protocol ProfileEditInteractable: Interactable {
    var router: ProfileEditRouting? { get set }
    var listener: ProfileEditListener? { get set }
}

protocol ProfileEditViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileEditRouter: ViewableRouter<ProfileEditInteractable, ProfileEditViewControllable>, ProfileEditRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileEditInteractable, viewController: ProfileEditViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
