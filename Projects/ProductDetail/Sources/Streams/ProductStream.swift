//
//  ProductStream.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import Entity

import RxSwift
import RxRelay

public protocol ProductStream: AnyObject {
  var productList: Observable<[ProductDTO]> { get }
}

public protocol MutableProductStream: ProductStream {
  func updateProductList(with productList: [ProductDTO])
  func updateProduct(product: ProductDTO)
  func updateSelectedIndex(index: Int)
}

public class ProductStreamImpl: MutableProductStream {
  
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init() {}
  
  private let list: BehaviorRelay<[ProductDTO]> = .init(value: [])
  
  private var selectedIndex: Int?
  
  public var productList: Observable<[ProductDTO]> {
    return list.asObservable().share()
  }
  
  public func updateProductList(with productList: [ProductDTO]) {
    list.accept(productList)
  }
  
  public func updateProduct(product: ProductDTO) {
    if let selectedIndex {
      var updatedData: [ProductDTO] = list.value
      updatedData[selectedIndex] = product
      list.accept(updatedData)
    }
  }
  
  public func updateSelectedIndex(index: Int) {
    selectedIndex = index
  }
}

