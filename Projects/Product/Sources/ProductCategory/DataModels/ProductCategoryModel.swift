//
//  ProductCategoryModel.swift
//  Product
//
//  Created by 구본의 on 2023/05/16.
//

import Foundation
import RxSwift
import RxDataSources

typealias ProductCategorySection = SectionModel<String, ProductCategoryModel>

struct ProductCategoryModel {
  var id: Int
  var title: String
  var imageURL: String?
}

extension ProductCategoryModel: IdentifiableType {
  public var identity: Int {
    return self.id
  }
}
