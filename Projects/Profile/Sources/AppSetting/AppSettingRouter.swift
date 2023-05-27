//
//  AppSettingRouter.swift
//  Profile
//
//  Created by 구본의 on 2023/05/27.
//

import RIBs

protocol AppSettingInteractable: Interactable {
    var router: AppSettingRouting? { get set }
    var listener: AppSettingListener? { get set }
}

protocol AppSettingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppSettingRouter: ViewableRouter<AppSettingInteractable, AppSettingViewControllable>, AppSettingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppSettingInteractable, viewController: AppSettingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
