//
//  StyleModel.swift
//  Entity
//
//  Created by 구본의 on 2023/05/04.
//

import UIKit

public struct StyleModel: Hashable {
  public let id: Int
  public let image: UIImage
  
  public init(id: Int, image: UIImage) {
    self.id = id
    self.image = image
  }
}
