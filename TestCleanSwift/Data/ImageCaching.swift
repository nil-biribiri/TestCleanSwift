//
//  ImageCaching.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 1/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension NSError {
  static func generalParsingError(domain: String) -> Error {
    return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
  }
}

class NilImageCaching {
  
  //MARK: - Public
  static func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
      return completion(cachedImage, nil)
    } else {
      NilImageCaching.downloadData(url: url) { data, response, error in
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
  func imageCaching(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    contentMode = mode
    NilImageCaching.downloadImage(url: url) { (image, error) in
      if (error != nil) { return }
      DispatchQueue.main.async() {
        self.image = image
      }
    }
  }
  
  func imageCaching(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    imageCaching(url: url, contentMode: mode)
  }
}


