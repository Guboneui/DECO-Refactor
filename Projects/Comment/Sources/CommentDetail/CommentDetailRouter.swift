//
//  CommentDetailRouter.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import RIBs

protocol CommentDetailInteractable: Interactable {
    var router: CommentDetailRouting? { get set }
    var listener: CommentDetailListener? { get set }
}

protocol CommentDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CommentDetailRouter: ViewableRouter<CommentDetailInteractable, CommentDetailViewControllable>, CommentDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CommentDetailInteractable, viewController: CommentDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
