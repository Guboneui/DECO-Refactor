//
//  SearchPhotoRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchPhotoInteractable: Interactable {
    var router: SearchPhotoRouting? { get set }
    var listener: SearchPhotoListener? { get set }
}

protocol SearchPhotoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchPhotoRouter: ViewableRouter<SearchPhotoInteractable, SearchPhotoViewControllable>, SearchPhotoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchPhotoInteractable, viewController: SearchPhotoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
