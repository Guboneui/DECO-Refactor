//
//  PhotoBookmarkInteractor.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol PhotoBookmarkRouting: ViewableRouting {

}

protocol PhotoBookmarkPresentable: Presentable {
  var listener: PhotoBookmarkPresentableListener? { get set }

}

protocol PhotoBookmarkListener: AnyObject {
  
}

final class PhotoBookmarkInteractor: PresentableInteractor<PhotoBookmarkPresentable>, PhotoBookmarkInteractable, PhotoBookmarkPresentableListener {
  
  weak var router: PhotoBookmarkRouting?
  weak var listener: PhotoBookmarkListener?
  
  var currentSelectedCategory: Int = -1
  var photoBookmarkCategory: BehaviorRelay<[(category: BoardCategoryDTO, isSelected: Bool)]> = .init(value: [])
  var photoBookmarkList: BehaviorRelay<[(bookmarkData: BookmarkDTO, isBookmark: Bool)]> = .init(value: [])
  
  private let userManager: MutableUserManagerStream
  private let boardRepository: BoardRepository
  private let bookmarkRepository: BookmarkRepository
  
  init(
    presenter: PhotoBookmarkPresentable,
    userManager: MutableUserManagerStream,
    boardRepository: BoardRepository,
    bookmarkRepository: BookmarkRepository
  ) {
    self.userManager = userManager
    self.boardRepository = boardRepository
    self.bookmarkRepository = bookmarkRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchBoardCategoryList()
    
    self.fetchBookmarkListWithCategory(
      categoryID: self.currentSelectedCategory,
      createdAt: Int.max
    )
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  private func fetchBoardCategoryList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let boardCategory = await self.boardRepository.boardCategoryList() {
        self.photoBookmarkCategory.accept(
          [(BoardCategoryDTO(categoryName: "전체", id: -1), true)] +
          boardCategory.sorted{$0.id < $1.id}.map{($0, false)}
        )
      }
    }
  }
  
  func fetchBookmarkListWithCategory(categoryID: Int, createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let bookmarkList = await self.bookmarkRepository.bookmarkList(
        userId: self.userManager.userID,
        scrapType: BookMarkSegmentType.Photo.rawValue,
        itemCategoryId: 0,
        boardCategoryId: categoryID,
        createdAt: createdAt
      ), !bookmarkList.isEmpty {
        let prevBookmarkList = self.photoBookmarkList.value
        let fetchedBookmarkList: [(BookmarkDTO, Bool)] = bookmarkList.map{($0, true)}
        self.photoBookmarkList.accept(prevBookmarkList + fetchedBookmarkList)
      }
    }
  }
  
  func selectPhotoBookmarkCategory(categoryID: Int, index: Int) {
    var categoryList: [(category: BoardCategoryDTO, isSelected: Bool)] = photoBookmarkCategory.value.map{($0.category, false)}
    categoryList[index].isSelected = true
    self.currentSelectedCategory = categoryID
    self.photoBookmarkCategory.accept(categoryList)
  }
  
  func fetchAddBookmark(with boardID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.bookmarkRepository.addBookmark(
        productId: 0,
        boardId: boardID,
        userId: self.userManager.userID
      )
    }
  }
  
  func fetchDeleteBookmark(with boardID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.bookmarkRepository.deleteBookmark(
        productId: 0,
        boardId: boardID,
        userId: self.userManager.userID
      )
    }
  }
}
