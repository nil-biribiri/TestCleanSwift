import Foundation

protocol RequestRefirer {
  func refireUrlRequest(urlRequest: URLRequest)
}

public protocol RequestInterceptor: class {
  func startRecording()
  func stopRecording()
}

public protocol RequestLogger: class {
//  func excludedDomain() -> [String]
  func logRequest(urlRequest: RequestModel)
}



public class NetworkInterceptor: NSObject {

  public static let shared = NetworkInterceptor()

  let logger: RequestLogger
  let interceptor: RequestInterceptor

  private override init(){
    interceptor = CustomUrlProtocolRequestInterceptor()
    logger = NetworkLogger()
  }

}

extension NetworkInterceptor: RequestInterceptor {
  public func startRecording(){
    interceptor.startRecording()
  }

  public func stopRecording(){
    interceptor.stopRecording()
  }
}


extension NetworkInterceptor: RequestRefirer {
  func refireUrlRequest(urlRequest: URLRequest) {

    let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
      do {
        _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
      } catch _ as NSError {
      }
      if error != nil{
        return
      }
    }
    task.resume()

  }

}

extension NetworkInterceptor {
  func logRequest(urlRequest: RequestModel){
    logger.logRequest(urlRequest: urlRequest)
  }
}

