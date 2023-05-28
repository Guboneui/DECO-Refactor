//
//  PhotoBookmarkRouter.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs

protocol PhotoBookmarkInteractable: Interactable {
    var router: PhotoBookmarkRouting? { get set }
    var listener: PhotoBookmarkListener? { get set }
}

protocol PhotoBookmarkViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PhotoBookmarkRouter: ViewableRouter<PhotoBookmarkInteractable, PhotoBookmarkViewControllable>, PhotoBookmarkRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PhotoBookmarkInteractable, viewController: PhotoBookmarkViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
