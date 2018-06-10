//
//  ImageCaching.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 1/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

private let imageCache:NSCache<NSString, UIImage> = {
  let imageCache = NSCache<NSString, UIImage>()
//  imageCache.totalCostLimit = 10*1024*1024 // Max 10MB used.
  return imageCache
}()

extension NSError {
  static func generalParsingError(domain: String) -> Error {
    return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
  }
}

typealias DownloadImageCompletion =  (_ image: UIImage?, _ error: Error? ) -> Void
typealias SetImageCompletion = (() -> Void)?

class NilImageCaching {

  //MARK: - Public
  static func downloadImage(url: URL, completion: @escaping DownloadImageCompletion ) {
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
      return completion(cachedImage, nil)
    } else {
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
      NilImageCaching.downloadData(url: url) { data, response, error in
        DispatchQueue.main.async {
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        if let error = error {
          return completion(nil, error)
        } else if let data = data,
          let image = UIImage(data: data),
          let mimeType = response?.mimeType, mimeType.hasPrefix("image") {
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            return completion(image, nil)
        } else {
          return completion(nil, NSError.generalParsingError(domain: url.absoluteString))
        }
      }
    }
  }
  
  //MARK: - Private
  fileprivate static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    URLSession(configuration: configuration).dataTask(with: URLRequest(url: url)) { data, response, error in
      completion(data, response, error)
      }.resume()
  }
  
}

extension UIImageView {
  func imageCaching(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit,
                    completion: SetImageCompletion = nil) {
    contentMode = mode

    self.image = UIImage(imageColor: .clear, imageSize: self.bounds.size)
    let loadingView = UIViewController().loading
    layoutIfNeeded()
    loadingView.view.frame = self.bounds
    self.addSubview(loadingView.view)

    NilImageCaching.downloadImage(url: url) { [weak self] (image, error) in
      if (error != nil) { return }
      DispatchQueue.main.async() {
        loadingView.view.removeFromSuperview()
        self?.image = image
        if let completion = completion {
          completion()
        }
      }
    }
  }
  
  func imageCaching(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit,
                    completion: SetImageCompletion = nil) {
    guard let url = URL(string: link) else { return }
    imageCaching(url: url, contentMode: contentMode, completion: completion)
  }
}

extension UIImage {
  public convenience init?(imageColor: UIColor, imageSize: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: imageSize)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    imageColor.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
