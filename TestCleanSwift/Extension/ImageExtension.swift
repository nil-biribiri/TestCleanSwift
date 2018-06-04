//
//  ImageExtension.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 31/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import UIKit

extension UIImageView {
  func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else {
          return
      }
      
      DispatchQueue.main.async() {
        self.image = image
      }
      }.resume()
  }
  func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    downloadedFrom(url: url, contentMode: mode)
  }
}

extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
