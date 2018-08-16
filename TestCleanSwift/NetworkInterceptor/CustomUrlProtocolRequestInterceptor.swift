import Foundation

extension CustomUrlProtocolRequestInterceptor: RequestInterceptor {
  public func startRecording() {
    URLProtocol.registerClass(CustormUrlProtocol.self)
    swizzleProtocolClasses()
  }

  public func stopRecording() {
    URLProtocol.unregisterClass(CustormUrlProtocol.self)
    swizzleProtocolClasses()
  }
}

@objc public class CustomUrlProtocolRequestInterceptor: NSObject{

  func swizzleProtocolClasses(){
    let instance = URLSessionConfiguration.default
    let uRLSessionConfigurationClass: AnyClass = object_getClass(instance)!

    let method1: Method = class_getInstanceMethod(uRLSessionConfigurationClass, #selector(getter: uRLSessionConfigurationClass.protocolClasses))!
    let method2: Method = class_getInstanceMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.swizzle_protocolClasses))!

    method_exchangeImplementations(method1, method2)
  }
}

extension URLSessionConfiguration {

  @objc func swizzle_protocolClasses() -> [AnyClass]? {

    var originalProtocolClasses = self.swizzle_protocolClasses()
    if let doesContain = originalProtocolClasses?.contains(where: { protocolClass in
      return protocolClass == CustormUrlProtocol.self
    }), !doesContain {
      originalProtocolClasses?.insert(CustormUrlProtocol.self, at: 0)
    }
    return originalProtocolClasses
  }

}

class CustormUrlProtocol: URLProtocol {

  struct Constants {
    static let RequestHandledKey = "URLProtocolRequestHandled"
  }

  var session: URLSession?
  var sessionTask: URLSessionDataTask?
  var currentRequest: RequestModel?

  override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
    super.init(request: request, cachedResponse: cachedResponse, client: client)

    if session == nil {
      session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
  }

  override public class func canInit(with request: URLRequest) -> Bool {
    if CustormUrlProtocol.property(forKey: Constants.RequestHandledKey, in: request) != nil {
      return false
    }
    return true
  }

  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override public func startLoading() {
    let newRequest = ((request as NSURLRequest).mutableCopy() as? NSMutableURLRequest)!
    CustormUrlProtocol.setProperty(true, forKey: Constants.RequestHandledKey, in: newRequest)
    sessionTask = session?.dataTask(with: newRequest as URLRequest)
    sessionTask?.resume()
    currentRequest = RequestModel(request: newRequest)
  }

  override public func stopLoading() {
    sessionTask?.cancel()
    currentRequest?.httpBody = body(from: request)
    if let startDate = currentRequest?.date{
      currentRequest?.duration = fabs(startDate.timeIntervalSinceNow) * 1000 //Find elapsed time and convert to milliseconds
    }
    NetworkInterceptor.shared.logRequest(urlRequest: currentRequest!)
  }

  private func body(from request: URLRequest) -> Data? {
    return request.httpBody ?? request.httpBodyStream.flatMap { stream in
      let data = NSMutableData()
      stream.open()
      while stream.hasBytesAvailable {
        var buffer = [UInt8](repeating: 0, count: 1024)
        let length = stream.read(&buffer, maxLength: buffer.count)
        data.append(buffer, length: length)
      }
      stream.close()
      return data as Data
    }
  }

}

extension CustormUrlProtocol: URLSessionDataDelegate {
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    client?.urlProtocol(self, didLoad: data)
    if currentRequest?.dataResponse == nil{
      currentRequest?.dataResponse = data
    }
    else{
      currentRequest?.dataResponse?.append(data)
    }
  }

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    let policy = URLCache.StoragePolicy(rawValue: request.cachePolicy.rawValue) ?? .notAllowed
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: policy)
    currentRequest?.initResponse(response: response)
    completionHandler(.allow)
  }

  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if let error = error {
      currentRequest?.errorClientDescription = error.localizedDescription
      client?.urlProtocol(self, didFailWithError: error)
    } else {
      client?.urlProtocolDidFinishLoading(self)
    }
  }

  public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
    client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    completionHandler(request)
  }

  public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    guard let error = error else { return }
    currentRequest?.errorClientDescription = error.localizedDescription
    client?.urlProtocol(self, didFailWithError: error)
  }

  public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    let protectionSpace = challenge.protectionSpace
    let sender = challenge.sender

    if protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
      if let serverTrust = protectionSpace.serverTrust {
        let credential = URLCredential(trust: serverTrust)
        sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
        return
      }
    }
  }

  public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    client?.urlProtocolDidFinishLoading(self)
  }
}

