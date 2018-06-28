import Foundation
//import GRSecurity

/// NSURLSession implementation of the HTTP protocol.
///
/// The requests are done synchronously. The logic behind the sync requests is that we can easily 
/// plug in RX extensions or promises to this implementation.
/// If you want to use it directly (without RX extensions or promises), you should do it in a 
/// background thread.
///
/// You can also use async requests with completion handler.
public class HTTPClient {

  static let shared = HTTPClient()

  private let sessionDelegate: DefaultSessionDelegate = DefaultSessionDelegate()
  private let urlSession: URLSession
  private(set) var requestsPool: [Request] = [Request]()

  /// Init method with possibility to customise the NSURLSession used for the requests.
  public init(urlSession: URLSession) {
    self.urlSession = urlSession
  }

  /// Init method that creates default NSURLSession with no response handlers.
  public init() {
    let configuration                           = URLSessionConfiguration.default
    configuration.requestCachePolicy            = .reloadIgnoringLocalAndRemoteCacheData
    configuration.timeoutIntervalForRequest     = 30
    configuration.timeoutIntervalForResource    = 30
    configuration.urlCache                      = nil

    self.urlSession = URLSession(configuration: configuration,
                                 delegate: sessionDelegate,
                                 delegateQueue: nil)
    sessionDelegate.httpClient = self
  }

  /// Extracts the credentials for a given url request.
  ///
  /// - Parameter request: The given url request.
  /// - Returns: The ssl credentials for a given request, returns nil if no credentials were found.
  //    public func credentialsForRequest(request: URLRequest) -> SSLCredentials? {
  //        for current in requestsPool {
  //            if request.matches(request: current) {
  //                return current.sslCredentials
  //            }
  //        }
  //        return nil
  //    }

}

// MARK: - HTTP protocol
extension HTTPClient: HTTP {

  enum ParseResult<_Result: Codable> {
    case success(_Result)
    case error(Error)
  }

  public func executeRequest<_Result: Codable>(request: Request) -> NResult<_Result> {
    var result: NResult<_Result> = NResult.failure(NetworkServiceError.cannotGetErrorMessage)
    let urlRequest: URLRequest = URLRequest(request: request)
    requestsPool.append(request)
    Logger.log(message: "Request: \(request)", event: .d)
    urlSession.sendSynchronousRequest(request: urlRequest) { [unowned self]
      data, urlResponse, error in
      self.removeFromPool(request: request)
      result = self.handleResponse(withData: data, urlResponse: urlResponse, error: error)
    }

    return result
  }

  public func get<_Result: Codable>(url: URL) -> NResult<_Result> {
    let request = Request(URL: url)
    return self.executeRequest(request: request)
  }

  public func executeRequest<_Result: Codable>(request: Request,
                                               completionHandler: @escaping (NResult<_Result>) -> Void) {
    let urlRequest: URLRequest = URLRequest(request: request)
    requestsPool.append(request)
    Logger.log(message: "Request: \(request)", event: .d)
    urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
      self.removeFromPool(request: request)
      let result: NResult<_Result> = self.handleResponse(withData: data,
                                                         urlResponse: urlResponse,
                                                         error: error)
      DispatchQueue.main.async {
        completionHandler(NetworkBaseService.transformServiceResponse(result))
      }
      }.resume()
  }

  public func get<_Result: Codable>(url: URL,
                                    completionHandler: @escaping (NResult<_Result>) -> Void) {
    let request = Request(URL: url)
    return self.executeRequest(request: request, completionHandler: completionHandler)
  }

  private func removeFromPool(request: Request) {
    //    requestsPool.removeAll(where: { $0 == request })
    if let index = self.requestsPool.index(of: request)  {
      self.requestsPool.remove(at: index)
    }
  }

  private func handleResponse<_Result: Codable>(withData data: Data?, urlResponse: URLResponse?, error: Error?)
    -> NResult<_Result> {
      if let data = data,
        let json  = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
        let logJson = json {
        Logger.log(message: "Response: \(logJson.prettyPrint())", event: .d)
      }
      if let error = error {
        let errorCode = (error as NSError).code
        switch errorCode {
        case -1001:
          return NResult.failure(NetworkServiceError.connectionTimeout(message: error.localizedDescription))
        case -1009:
          return NResult.failure(NetworkServiceError.noInternetConnection(message: error.localizedDescription))
        default:
          return NResult.failure(NetworkServiceError.unknownError(message: error.localizedDescription))
        }
      }
      if let httpResponse = urlResponse as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200..<300:
          let bodyObject: ParseResult<_Result> = self.parseBody(data: data)
          switch bodyObject {
          case .success(let bodyObject):
            let response: Response<_Result> = Response(statusCode: httpResponse.statusCode,
                                                       body: data as Data?,
                                                       bodyObject: bodyObject,
                                                       responseHeaders: httpResponse.allHeaderFields,
                                                       url: httpResponse.url)
            return NResult.success(response)
          case .error(let error):
            return NResult.failure(error)
          }
        case 401:
          handleUnauthorized()
        default:
          let responseError = parseError(data: data, statusCode: httpResponse.statusCode)
          return NResult.failure(responseError)
        }
      }
      return NResult.failure(NetworkServiceError.cannotGetErrorMessage)
  }

  /// Parses the response body data.
  ///
  /// - Parameter data: The data object which should be parsed.
  /// - Returns: The expected generic Object, nil when the data cannot be parsed.
  private func parseBody<_Result: Codable>(data: Data?) -> ParseResult<_Result> {
    do {
      // Decode result to object
      let jsonDecoder = JSONDecoder()
      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
      if let data  = data {
        let result  = try jsonDecoder.decode(_Result.self, from: data)
        return ParseResult.success(result)
      } else {
        return ParseResult.error(NetworkServiceError.cannotGetErrorMessage)
      }
    } catch let error {
      // parseJSON Error
      let decodingError = error as? DecodingError
      return ParseResult.error(NetworkServiceError.parseJSONError(resultType: String(describing: _Result.self), message: decodingError.debugDescription))
    }
  }

  private func parseError(data: Data?, statusCode: Int) -> Error {
    let errorMessage = "Unknown Error."
    if let data  = data {
      let logJson  = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
      if let errorMessageFromPayload = getErrorFromPayload(json: logJson){
        // Error message found in payload
        let displayCode = (errorMessageFromPayload.statusCode ?? String(statusCode))
        let message     = (errorMessageFromPayload.statusMessage ?? errorMessage)
        return NetworkServiceError.receiveErrorFromService(statusCode: statusCode,
                                                                             displayCode: displayCode,
                                                                             message: message)
      }
    }
    return NetworkServiceError.unknownError(message: errorMessage)
  }

  private func getErrorFromPayload(json: [String:AnyObject]??) -> (statusCode: String?, statusMessage: String?)? {
    guard let serializeJSON = json, let convertedJSON = serializeJSON else {
      return nil
    }
    if let statusCode = convertedJSON["status_code"],
      let statusMessage = convertedJSON["status_message"] {
      return (statusCode: statusCode as? String, statusMessage: statusMessage as? String)
    }

    if let errorArr = convertedJSON["errors"],
      let errorStatus = (errorArr as? [String])?.first {
      return (nil, statusMessage: errorStatus)
    }

    return nil
  }
}

/// Extension of the NSURLSession that blocks the data task with semaphore, so we can perform
/// a sync request.
extension URLSession {
  func sendSynchronousRequest(
    request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let semaphore = DispatchSemaphore(value: 0)
    let task = self.dataTask(with: request) { data, response, error in
      completionHandler(data, response, error)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
  }
}

/// Adapting our definition of the Request to the one from the iOS SDK.
extension URLRequest {

  public init(request: Request) {
    self.init(url: request.url as URL)
    self.httpMethod = request.method.rawValue
    self.allHTTPHeaderFields = request.headerFields
    self.httpBody = request.body as Data?
  }

  func matches(request: Request) -> Bool {
    return self.url!.absoluteString == request.url.absoluteString
      && self.httpMethod! == request.method.rawValue
      && self.allHTTPHeaderFields! == request.headerFields
      && self.httpBody == request.body
  }
}