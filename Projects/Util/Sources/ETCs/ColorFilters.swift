//
//  ColorFilters.swift
//  Util
//
//  Created by 구본의 on 2023/06/04.
//

import UIKit

public struct ProductColorModel {
  public let name: String
  public let image: UIImage
  public let id: Int
  
  public init(name: String, image: UIImage, id: Int) {
    self.name = name
    self.image = image
    self.id = id
  }
}

public let ProductColorModels: [ProductColorModel] = [
  ProductColorModel(name: "흑백", image: UtilAsset.bw.image, id: 0),
  ProductColorModel(name: "레드", image: UtilAsset.red.image, id: 1),
  ProductColorModel(name: "오렌지", image: UtilAsset.orange.image, id: 2),
  ProductColorModel(name: "옐로우", image: UtilAsset.yellow.image, id: 3),
  ProductColorModel(name: "그린", image: UtilAsset.green.image, id: 4),
  ProductColorModel(name: "블루", image: UtilAsset.blue.image, id: 5),
  ProductColorModel(name: "네이비", image: UtilAsset.navy.image, id: 7),
  ProductColorModel(name: "베이지", image: UtilAsset.beige.image, id: 8),
  ProductColorModel(name: "브라운", image: UtilAsset.brown.image, id: 9),
  ProductColorModel(name: "퍼플", image: UtilAsset.purple.image, id: 10),
  ProductColorModel(name: "핑크", image: UtilAsset.pink.image, id: 11),
  ProductColorModel(name: "블랙", image: UtilAsset.black.image, id: 12),
  ProductColorModel(name: "그레이", image: UtilAsset.grey.image, id: 13),
  ProductColorModel(name: "화이트", image: UtilAsset.white.image, id: 14),
  ProductColorModel(name: "다색", image: UtilAsset.rainbow.image, id: 15)
]

public func getColorImage(id: Int) -> UIImage {
  if id == 0 { return UtilAsset.bw.image }
  else if id == 1 { return UtilAsset.red.image }
  else if id == 2 { return UtilAsset.orange.image }
  else if id == 3 { return UtilAsset.yellow.image }
  else if id == 4 { return UtilAsset.green.image }
  else if id == 5 { return UtilAsset.blue.image }
  else if id == 7 { return UtilAsset.navy.image }
  else if id == 8 { return UtilAsset.beige.image }
  else if id == 9 { return UtilAsset.brown.image }
  else if id == 10 { return UtilAsset.purple.image }
  else if id == 11 { return UtilAsset.pink.image }
  else if id == 12 { return UtilAsset.black.image }
  else if id == 13 { return UtilAsset.grey.image }
  else if id == 14 { return UtilAsset.white.image }
  else { return UtilAsset.rainbow.image }
}
