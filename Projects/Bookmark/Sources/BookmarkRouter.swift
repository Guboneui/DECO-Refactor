//
//  BookmarkRouter.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs

protocol BookmarkInteractable: Interactable {
    var router: BookmarkRouting? { get set }
    var listener: BookmarkListener? { get set }
}

public protocol BookmarkViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BookmarkRouter: ViewableRouter<BookmarkInteractable, BookmarkViewControllable>, BookmarkRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BookmarkInteractable, viewController: BookmarkViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
