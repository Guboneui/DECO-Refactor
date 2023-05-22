//
//  BrandDetailViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import UIKit

import CommonUI
import Util

import RIBs
import RxSwift
import RxCocoa

protocol BrandDetailPresentableListener: AnyObject {
  func popBrandDetailVC(with popType: PopType)
}

final class BrandDetailViewController: UIViewController, BrandDetailPresentable, BrandDetailViewControllable {
  
  weak var listener: BrandDetailPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: false
  )
  
  private let tableView: UITableView = UITableView().then {
    $0.backgroundColor = .green
    $0.bounces = false
    $0.estimatedRowHeight = 50.0
    $0.rowHeight = UITableView.automaticDimension
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupTableView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popBrandDetailVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  // MARK: - Private Method
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(tableView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    tableView.pin
      .below(of: navigationBar)
      .horizontally()
      .bottom()
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popBrandDetailVC(with: .BackButton)
    }
  }
  
  private func setupTableView() {
    //self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
}

extension BrandDetailViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(indexPath)"
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 2 {
      let view = UIView()
      view.backgroundColor = .yellow
      //view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 75)
      return view
    } else {
      return nil
    }
    
  }
}
