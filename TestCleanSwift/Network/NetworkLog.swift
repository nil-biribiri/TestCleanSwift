//
//  NetworkLog.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 5/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == AnyObject {
  func prettyPrint() -> String{
    var string: String = ""
    if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
      if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
        string = nstr as String
      }
    }
    return string
  }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

extension String {
  func snakeCased() -> String {
    let pattern = "([a-z0-9])([A-Z])"
    
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: self.count)
    return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased() ?? self
  }
}
