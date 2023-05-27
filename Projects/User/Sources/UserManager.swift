//
//  UserManager.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/05/28.
//

import RxSwift
import RxRelay

public struct UserManagerModel {
  public var nickname: String
  public var profileUrl: String
  public var backgroundUrl: String
  public var profileDescription: String
  public var profileName: String
  public var followCount: Int
  public var followingCount: Int
  public var boardCount: Int
  public var userId: Int
  public var followStatus: Bool
  
  public static func equals(lhs: UserManagerModel, rhs: UserManagerModel) -> Bool {
    return lhs.userId == rhs.userId
  }
  
  public init(nickname: String, profileUrl: String, backgroundUrl: String, profileDescription: String, profileName: String, followCount: Int, followingCount: Int, boardCount: Int, userId: Int, followStatus: Bool) {
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.backgroundUrl = backgroundUrl
    self.profileDescription = profileDescription
    self.profileName = profileName
    self.followCount = followCount
    self.followingCount = followingCount
    self.boardCount = boardCount
    self.userId = userId
    self.followStatus = followStatus
  }
}

public protocol UserManagerStream: AnyObject {
  var userInfo: Observable<UserManagerModel> { get }
  var userID: Int { get }
}

public protocol MutableUserManagerStream: UserManagerStream {
  func updateUserInfo(with user: UserManagerModel)
  func updateUserNickname(nickname: String)
  func updateUserProfileImageURL(url: String)
  func updateUserBackgroundImageURL(url: String)
  func updateUserProfileDescription(description: String)
  func updateUserProfileName(profileName: String)
}

public class UserManagerStreamImpl: MutableUserManagerStream {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init() {}
  
  public var userID: Int = 0
  
  public var userInfo: Observable<UserManagerModel> {
    return userProfile
      .asObservable()
//      .distinctUntilChanged { (lhs: UserManagerModel, rhs: UserManagerModel) -> Bool in
//        UserManagerModel.equals(lhs: lhs, rhs: rhs)
//      }
  }
  
  public func updateUserInfo(with user: UserManagerModel) {
    userID = user.userId
    userProfile.accept(user)
  }
  
  public func updateUserNickname(nickname: String) {
    var userProfile = userProfile.value
    userProfile.nickname = nickname
    self.userProfile.accept(userProfile)
  }
  
  public func updateUserProfileImageURL(url: String) {
    var userProfile = userProfile.value
    userProfile.profileUrl = url
    self.userProfile.accept(userProfile)
  }
  
  public func updateUserBackgroundImageURL(url: String) {
    var userProfile = userProfile.value
    userProfile.backgroundUrl = url
    self.userProfile.accept(userProfile)
  }
  
  public func updateUserProfileDescription(description: String) {
    var userProfile = userProfile.value
    userProfile.profileDescription = description
    self.userProfile.accept(userProfile)
  }
  
  public func updateUserProfileName(profileName: String) {
    var userProfile = userProfile.value
    userProfile.profileName = profileName
    self.userProfile.accept(userProfile)
  }
  
  private let userProfile = BehaviorRelay<UserManagerModel>(
    value: UserManagerModel(
      nickname: "",
      profileUrl: "",
      backgroundUrl: "",
      profileDescription: "",
      profileName: "",
      followCount: 0,
      followingCount: 0,
      boardCount: 0,
      userId: 0,
      followStatus: false
    )
  )
}
