//
//  ProfileRouter.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs

protocol ProfileInteractable: Interactable {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }
}

public protocol ProfileViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable>, ProfileRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileInteractable, viewController: ProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
