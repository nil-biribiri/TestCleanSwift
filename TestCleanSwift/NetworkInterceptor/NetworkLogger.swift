import Foundation

class NetworkLogger: RequestLogger {

  func logRequest(urlRequest: RequestModel) {
    var prettyResponse: String?
    if let jsonResponse = urlRequest.dataResponse?.toDictionary() {
      prettyResponse = jsonResponse.prettyPrint()
    }

    print("""
      ********NetworkLogger********
      -> URL     : \(urlRequest.url)
      -> Method  : \(urlRequest.method)
      -> Headers : \(urlRequest.headers)
      -> Body    : \(urlRequest.httpBody?.toDictionary()?.prettyPrint() ?? "")
      -> Response: \(prettyResponse ?? urlRequest.dataResponse?.description ?? "")
      -> Error   : \(urlRequest.errorClientDescription ?? "")
      *****************************
      """)
  }
}

extension Data {
  func toDictionary() -> [String: AnyObject]? {
    if let json  = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: AnyObject],
    let logJson = json {
      return logJson
    } else {
      return nil
    }
  }
}

extension Dictionary where Key == String, Value == AnyObject {
  func prettyPrint() -> String {
    var string: String = ""
    if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
      if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        string = nstr as String
      }
    }
    return string
  }
}
