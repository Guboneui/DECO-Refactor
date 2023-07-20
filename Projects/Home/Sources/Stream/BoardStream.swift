//
//  BoardStream.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import Entity

import RxSwift
import RxRelay

public protocol BoardStream: AnyObject {
  var boardList: Observable<[PostingDTO]> { get }
}

public protocol MutableBoardStream: BoardStream {
  func updateBoardList(with boardList: [PostingDTO])
}

public class BoardStreamImpl: MutableBoardStream {
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init() {}
  
  private let list: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  public var boardList: Observable<[PostingDTO]> {
    return list.asObservable().share()
  }
  
  public func updateBoardList(with boardList: [PostingDTO]) {
    list.accept(boardList)
  }
}
