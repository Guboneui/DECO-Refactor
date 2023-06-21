//
//  ToastManager.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/21.
//

import UIKit

public enum ToastMessage: String {
  case DeleteBookmark = "저장목록에서 삭제되었습니다"
  case AddBookmark = "저장목록에 추가되었습니다"
  case Withdraw = "탈퇴었습니다"
  case LogOut = "로그아웃 되었습니다"
  case AppReview = "보내주신 의견이 정상적으로 접수되었습니다 :)"
  case NicknameIsSame = "이미 사용중인 닉네임입니다"
  case MaximumKeyword = "최대 5개까지 등록할 수 있어요"
  case ExistKeyword = "이미 등록된 키워드에요"
  case InitialSoundKeyword = "초성은 등록할 수 없는 키워드에요"
  case EmoticonKeyword = "특수문자 및 이모티콘은 등록할 수 없는 키워드에요"
  case KoreanKeyword = "키워드는 한글로만 등록 가능해요"
  case ProductNoLink = "위 상품은 연결된 링크가 없어요"
  case Blame = "신고가 성공적으로 접수되었습니다.\n(신고하신 내용은 관리자 검토 후 내부정책 하에 조치를 진행할 예정입니다.)"
  case UserBlock = "상대방이 차단되었습니다"
  case UserUnblock = "상대방이 차단 해제되었습니다"
}

public class ToastManager {
  public static let shared = ToastManager()
  
  private var window = UIApplication.shared.connectedScenes.first as? UIWindowScene
  
  public func showToast(_ toastType: ToastMessage) {
    if let windowScene = window,
       let rootVC = windowScene.windows.first?.rootViewController {
      
      let toastContainerView: UIView = UIView().then {
        $0.backgroundColor = .DecoColor.darkGray2
        $0.alpha = 0.0
        $0.makeCornerRadius(radius: 4)
      }
      
      let toastLabel: UILabel = UILabel().then {
        $0.text = toastType.rawValue
        $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
        $0.textColor = .DecoColor.whiteColor
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
      }
      
      rootVC.view.addSubview(toastContainerView)
      toastContainerView.addSubview(toastLabel)
      toastContainerView.pin
        .bottom(rootVC.view.pin.safeArea)
        .horizontally(20)
      
      toastLabel.pin
        .vertically()
        .horizontally(20)
        .sizeToFit(.width)
      
      toastContainerView.pin.wrapContent(.vertically, padding: 12)
      
      rootVC.view.bringSubviewToFront(toastContainerView)
      showAnimation(at: rootVC, with: toastContainerView)
    }
  }
  
  private func showAnimation(at rootVC: UIViewController, with toastView: UIView) {
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      options: .curveEaseIn,
      animations: {
        toastView.pin
          .bottom(rootVC.view.pin.safeArea)
          .horizontally(20)
          .marginBottom(12)
        
        toastView.alpha = 1.0
      }) { [weak self] _ in
        self?.hideAnimation(at: rootVC, with: toastView)
      }
  }
  
  private func hideAnimation(at rootVC: UIViewController, with toastView: UIView) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: .curveEaseOut
      ) {
        toastView.alpha = 0.0
        toastView.pin
          .bottom(rootVC.view.pin.safeArea)
          .horizontally(20)
      }
    }
  }
}
