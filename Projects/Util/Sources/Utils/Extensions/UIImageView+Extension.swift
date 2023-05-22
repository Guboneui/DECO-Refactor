//
//  UIImageView+Extension.swift
//  Util
//
//  Created by 구본의 on 2023/05/16.
//

import UIKit
import Nuke

public extension UIImageView {
  func loadLowQualityImage(imageUrl: String, _ completion: (() -> Void)? = nil) {
    Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
    (ImagePipeline.shared.configuration.dataLoader as? DataLoader)?.session.configuration.urlCache?.removeAllCachedResponses()
    let resizeProcessor = ImageProcessors.Resize(size: CGSize(width: 50, height: 50))
    let request = ImageRequest(url: URL(string: imageUrl),
                               processors: [resizeProcessor],
                               priority: .high)
    Nuke.loadImage(with: request, into: self) { _ in
      completion?()
    }
  }
  
  func loadImage(imageUrl: String, _ completion: (() -> Void)? = nil) {
    Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
    (ImagePipeline.shared.configuration.dataLoader as? DataLoader)?.session.configuration.urlCache?.removeAllCachedResponses()
    let resizeProcessor = ImageProcessors.Resize(size: CGSize(width: 300, height: 300))
    let request = ImageRequest(url: URL(string: imageUrl),
                               processors: [resizeProcessor],
                               priority: .high)
    Nuke.loadImage(with: request, into: self) { _ in
      completion?()
    }
  }
  
  func loadImageWithThumbnail(thumbnail: UIImage, imageUrl: String, _ completion: (() -> Void)? = nil) {
    Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
    (ImagePipeline.shared.configuration.dataLoader as? DataLoader)?.session.configuration.urlCache?.removeAllCachedResponses()
    let options = ImageLoadingOptions(placeholder: thumbnail, transition: .fadeIn(duration: 0.2))
    let resizeProcessor = ImageProcessors.Resize(size: CGSize(width: 300, height: 300))
    let request = ImageRequest(url: URL(string: imageUrl),
                               processors: [resizeProcessor],
                               priority: .high)
    Nuke.loadImage(with: request, options: options, into: self) { _ in
      completion?()
    }
  }
}

