//
//  UserSignUpInfoStream.swift
//  Login
//
//  Created by 구본의 on 2023/05/07.
//

import RxSwift
import RxRelay

struct UserSignUpModel {
  let email: String?
  let nickname: String?
  let gender: GenderType?
  let age: AgeType?
  let moods: [Int]?
  
  public static func equals(lhs: UserSignUpModel, rhs: UserSignUpModel) -> Bool {
    return lhs.nickname == rhs.nickname
  }
}

protocol UserSignUpStream: AnyObject {
  var signupInfo: Observable<UserSignUpModel> { get }
}

protocol MutableSignUpStream: UserSignUpStream {
  func updateEmail(email: String?)
  func updateNickname(nickname: String?)
  func updateGender(gender: GenderType?)
  func updateAge(age: AgeType?)
  func updateMoods(moods: [Int]?)
  
}

class UserSignUpStreamImpl: MutableSignUpStream {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  var signupInfo: Observable<UserSignUpModel> {
    return userInfo
      .asObservable()
      .distinctUntilChanged { (lhs: UserSignUpModel, rhs: UserSignUpModel) -> Bool in
        UserSignUpModel.equals(lhs: lhs, rhs: rhs)
      }
  }
  
  func updateEmail(email: String?) {
    let updatedInfo: UserSignUpModel = {
      let currentInfo = userInfo.value
      return UserSignUpModel(email: email,
                             nickname: currentInfo.nickname,
                             gender: currentInfo.gender,
                             age: currentInfo.age,
                             moods: currentInfo.moods)
    }()
    userInfo.accept(updatedInfo)
  }
 
  func updateNickname(nickname: String?) {
    let updatedInfo: UserSignUpModel = {
      let currentInfo = userInfo.value
      return UserSignUpModel(email: currentInfo.email,
                             nickname: nickname,
                             gender: currentInfo.gender,
                             age: currentInfo.age,
                             moods: currentInfo.moods)
    }()
    userInfo.accept(updatedInfo)
    print("🔊[DEBUG]: UPDATED: \(userInfo.value)")
  }
  
  func updateGender(gender: GenderType?) {
    let updatedInfo: UserSignUpModel = {
      let currentInfo = userInfo.value
      return UserSignUpModel(email: currentInfo.email,
                             nickname: currentInfo.nickname,
                             gender: gender,
                             age: currentInfo.age,
                             moods: currentInfo.moods)
    }()
    userInfo.accept(updatedInfo)
    print("🔊[DEBUG]: UPDATED: \(userInfo.value)")
  }
  
  func updateAge(age: AgeType?) {
    let updatedInfo: UserSignUpModel = {
      let currentInfo = userInfo.value
      return UserSignUpModel(email: currentInfo.email,
                             nickname: currentInfo.nickname,
                             gender: currentInfo.gender,
                             age: age,
                             moods: currentInfo.moods)
    }()
    userInfo.accept(updatedInfo)
    print("🔊[DEBUG]: UPDATED: \(userInfo.value)")
  }
  
  func updateMoods(moods: [Int]?) {
    let updatedInfo: UserSignUpModel = {
      let currentInfo = userInfo.value
      return UserSignUpModel(email: currentInfo.email,
                             nickname: currentInfo.nickname,
                             gender: currentInfo.gender,
                             age: currentInfo.age,
                             moods: moods)
    }()
    userInfo.accept(updatedInfo)
    print("🔊[DEBUG]: UPDATED: \(userInfo.value)")
  }
  
  
  private let userInfo = BehaviorRelay<UserSignUpModel>(value: UserSignUpModel(email: nil, nickname: nil, gender: nil, age: nil, moods: nil))
}
