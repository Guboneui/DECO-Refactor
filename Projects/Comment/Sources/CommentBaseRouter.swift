//
//  CommentBaseRouter.swift
//  Comment
//
//  Created by 구본의 on 2023/07/25.
//

import RIBs

protocol CommentBaseInteractable: Interactable {
    var router: CommentBaseRouting? { get set }
    var listener: CommentBaseListener? { get set }
}

protocol CommentBaseViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CommentBaseRouter: ViewableRouter<CommentBaseInteractable, CommentBaseViewControllable>, CommentBaseRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CommentBaseInteractable, viewController: CommentBaseViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
  
}
