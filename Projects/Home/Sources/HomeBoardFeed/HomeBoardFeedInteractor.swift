//
//  HomeBoardFeedInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/07/25.
//

import Util
import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol HomeBoardFeedRouting: ViewableRouting {
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO)
  func detachTargetUserProfileVC(with popType: PopType)
  func attachCommentBaseRIB(with boardID: Int)
  func detachCommentBaseRIB()
  @MainActor func attachProductDetailVC(with productInfo: ProductDTO)
  func detachProductDetailVC(with popType: PopType)
}

protocol HomeBoardFeedPresentable: Presentable {
  var listener: HomeBoardFeedPresentableListener? { get set }
  @MainActor func showToast(status: Bool)
  func showAlert(isMine: Bool)
  func moveToStartIndex(at index: Int)
}

protocol HomeBoardFeedListener: AnyObject {
  func popHomeBoardFeedVC(with popType: PopType)
}

final class HomeBoardFeedInteractor: PresentableInteractor<HomeBoardFeedPresentable>, HomeBoardFeedInteractable, HomeBoardFeedPresentableListener {
  
  weak var router: HomeBoardFeedRouting?
  weak var listener: HomeBoardFeedListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let feedStartIndex: Int
  private let feedType: HomeType
  
  var boardList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  private let boardListStream: MutableBoardStream
  private let userManager: MutableUserManagerStream
  private let bookmarkRepository: BookmarkRepository
  private let boardRepository: BoardRepository
  private let productRepository: ProductRepository
  private let postingCategoryFilter: MutableSelectedPostingFilterStream
  
  private var selectedBoardId: [Int] = []
  private var selectedStyleId: [Int] = []
  
  init(
    presenter: HomeBoardFeedPresentable,
    feedStartIndex: Int,
    feedType: HomeType,
    boardListStream: MutableBoardStream,
    userManager: MutableUserManagerStream,
    bookmarkRepository: BookmarkRepository,
    boardRepository: BoardRepository,
    productRepository: ProductRepository,
    postingCategoryFilter: MutableSelectedPostingFilterStream
  ) {
    self.feedStartIndex = feedStartIndex
    self.feedType = feedType
    self.boardListStream = boardListStream
    self.userManager = userManager
    self.bookmarkRepository = bookmarkRepository
    self.boardRepository = boardRepository
    self.productRepository = productRepository
    self.postingCategoryFilter = postingCategoryFilter
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.setupBindings()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popHomeBoardFeedVC(with popType: PopType) {
    listener?.popHomeBoardFeedVC(with: popType)
  }
  
  private func setupBindings() {
    boardListStream.boardList
      .subscribe(onNext: { [weak self] list in
        self?.boardList.accept(list)
      }).disposed(by: disposeBag)
    
    postingCategoryFilter.selectedFilter
      .take(1) // 사이드 이팩트 방지하기 위해서 1회만 호출
      .share()
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let boardId: [Int] = filter.selectedBoardCategory.map{$0.id}
        let styleId: [Int] = filter.selectedStyleCategory.map{$0.id}
        self.selectedBoardId = boardId
        self.selectedStyleId = styleId
      }).disposed(by: disposeBag)
    
    
    Observable.just(feedStartIndex)
      .take(1)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] startIndex in
        guard let self else { return }
        self.presenter.moveToStartIndex(at: startIndex)
      }).disposed(by: disposeBag)
  }
  
  func fetchBoardBookmark(at index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let currentBoard: PostingDTO = self.boardList.value[index]
      guard let scrapStatus = currentBoard.scrap,
            let boardID = currentBoard.id else { return }
      if scrapStatus == true {
        _ = await self.bookmarkRepository.deleteBookmark(
          productId: 0,
          boardId: boardID,
          userId: self.userManager.userID
        )
      } else {
        _ = await self.bookmarkRepository.addBookmark(
          productId: 0,
          boardId: boardID,
          userId: self.userManager.userID
        )
      }
      
      if let updatedBoard = await self.boardRepository.boardInfo(boardID: boardID, userID: self.userManager.userID) {
        await self.updatedBoardList(at: index, updatedBoard: updatedBoard)
      }
      await self.presenter.showToast(status: scrapStatus)
    }
  }
  
  func fetchBoardLike(at index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let currentBoard: PostingDTO = self.boardList.value[index]
      guard let likeStatus = currentBoard.like,
            let boardID = currentBoard.id else { return }
      
      if likeStatus == true {
        _ = await self.boardRepository.boardDisLike(boardID: boardID, userID: self.userManager.userID)
      } else {
        _ = await self.boardRepository.boardLike(boardID: boardID, userID: self.userManager.userID)
      }
      
      if let updatedBoard = await self.boardRepository.boardInfo(boardID: boardID, userID: self.userManager.userID) {
        await self.updatedBoardList(at: index, updatedBoard: updatedBoard)
      }
    }
  }
  
  private func updatedBoardList(at index: Int, updatedBoard: PostingDTO) async {
    var boardData: [PostingDTO] = self.boardList.value
    boardData[index] = updatedBoard
    boardListStream.updateBoardList(with: boardData)
  }
  
  func checkCurrentBoardUser(at index: Int) {
    let currentBoard: PostingDTO = self.boardList.value[index]
    guard let boardUserID = currentBoard.userId else { return }
    let currentUserID = userManager.userID
    presenter.showAlert(isMine: boardUserID == currentUserID)
  }
  
  func pushTargetUserProfileVC(at index: Int) {
    let currentBoard: PostingDTO = self.boardList.value[index]
    guard let boardUserID = currentBoard.userId,
          let profileURL = currentBoard.profileUrl,
          let followStatus = currentBoard.follow,
          let nickName = currentBoard.userName,
          let profileName = currentBoard.profileName else { return }
    
    let targetUserInfo: UserDTO = UserDTO(
      profileUrl: profileURL,
      followStatus: followStatus,
      nickName: nickName,
      userId: boardUserID,
      profileName: profileName
    )
    router?.attachTargetUserProfileVC(with: targetUserInfo)
  }
  
  func popTargetUserProfileVC(with popType: Util.PopType) {
    router?.detachTargetUserProfileVC(with: popType)
  }
  
  func fetchBoardList(lastIndex index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let createdAt: Int = self.boardList.value[index].createdAt ?? Int.max
      
      var boardType: String {
        switch self.feedType {
        case .Recent: return BoardType.LATEST.rawValue
        case .Follow: return BoardType.FOLLOW.rawValue
        case .Popular: return BoardType.LIKE.rawValue
        }
      }
      
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: createdAt,
          listType: boardType,
          keyword: "",
          styleIds: self.selectedStyleId,
          colorIds: [],
          boardCategoryIds: self.selectedBoardId,
          userId: self.userManager.userID
        )
      ), !boardList.isEmpty {
        let prevList = self.boardList.value
        self.boardListStream.updateBoardList(with: prevList + boardList)
      }
    }
  }
  
  func presentCommentBaseVC(at index: Int) {
    guard let boardID: Int = boardList.value[index].id else { return }
    self.router?.attachCommentBaseRIB(with: boardID)
  }
  
  func dismissCommentVC() {
    self.router?.detachCommentBaseRIB()
  }
  
  func fetchDeleteBoard(at index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let currentBoard = self.boardList.value[index]
      guard let boardID: Int = currentBoard.id else { return }
      _ = await self.boardRepository.boardDelete(
        userID: self.userManager.userID,
        boardID: boardID
      )
      await self.deleteBoardList(at: index)
    }
  }
  
  private func deleteBoardList(at index: Int) async {
    var currentBoardList = boardList.value
    currentBoardList.remove(at: index)
    self.boardListStream.updateBoardList(with: currentBoardList)
  }
  
  func pushProductDetailVC(with productID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let productInfo = await self.productRepository.getProductInfo(
        productID: productID,
        userID: self.userManager.userID
      ) {
        let product: ProductDTO = ProductDTO(
          name: productInfo.product.name,
          imageUrl: productInfo.product.imageUrl,
          brandName: productInfo.brandName,
          id: productInfo.product.id,
          scrap: productInfo.scrap,
          createdAt: productInfo.product.createdAt
        )
        await self.router?.attachProductDetailVC(with: product)
      }
    }
  }
  
  func popProductDetailVC(with popType: Util.PopType) {
    router?.detachProductDetailVC(with: popType)
  }
}
