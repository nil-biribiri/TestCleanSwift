import Foundation

/// Enum for the different types of http methods.
public enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case HEAD
  case DELETE
  case PATCH
  case TRACE
  case OPTIONS
  case CONNECT
}

/// The Request type which the HTTP protocol expects.
///
/// All of its properties are immutable. 
/// Different init methods are provided, with or without the ServiceEndpoint and RequestGenerator.
public struct Request: Equatable {
  public let url: URL
  public let method: HTTPMethod
  public let parameters: Any?
  public let headerFields: [String: String]
  public let body: Data?
  //    public let sslCredentials: SSLCredentials?

  public static func ==(l: Request, r: Request) -> Bool {
    return l.url.absoluteString == r.url.absoluteString
      && l.body == r.body
      && l.headerFields == r.headerFields
      && l.method == r.method
  }


  /// Initialize with a given service endpoint.
  ///
  /// It is the caller's responsibility to ensure that the values represent valid `ServiceEndpoint` values, if that is what is desired.
  public init(endpoint: ServiceEndpoint) {
    var mutableRequest = endpoint.requestGenerator.generateRequest(withMethod: endpoint.method)
    mutableRequest.updateParameters(parameters: endpoint.parameters)
    mutableRequest.updateQueryParameters(parameters: endpoint.queryParameters)
    let path = endpoint.baseURL.appendingPathComponent(endpoint.path)

    if mutableRequest.queryString != nil {
      if let queryString = path.appendQueryString(queryString: mutableRequest.queryString!) {
        self.url = queryString
      } else {
        self.url = path as URL
      }
    } else {
      self.url = path as URL
    }

    self.method = endpoint.method
    self.parameters = mutableRequest.parameters

    if mutableRequest.parameters != nil && mutableRequest.method != .GET {
      self.body = mutableRequest.body
    } else {
      self.body = nil
    }

    self.headerFields = mutableRequest.headerFields
    //        self.sslCredentials = mutableRequest.sslCredentials
  }

  public init(URL: URL,
              method: HTTPMethod,
              parameters: Codable? = nil,
              queryParameters: [String: String]? = [:],
              requestGenerator: RequestGenerator) {
    var mutableRequest = requestGenerator.generateRequest(withMethod: method)
    mutableRequest.updateParameters(parameters: parameters)
    mutableRequest.updateQueryParameters(parameters: queryParameters)

    if method == .GET && mutableRequest.queryString != nil {
      if let queryString = URL.appendQueryString(queryString: mutableRequest.queryString!) {
        self.url = queryString
      } else {
        self.url = URL
      }
    } else {
      self.url = URL
    }

    self.method = method
    self.parameters = mutableRequest.parameters

    if mutableRequest.parameters != nil && mutableRequest.method != .GET {
      self.body = mutableRequest.body
    } else {
      self.body = nil
    }

    self.headerFields = mutableRequest.headerFields
    //        self.sslCredentials = mutableRequest.sslCredentials
  }

  public init(URL: URL, method: HTTPMethod = .GET, queryParameters: [String: String] = [:]) {
    let requestGenerator = StandardRequestGenerator()
    self.init(URL: URL,
              method: method,
              queryParameters: queryParameters,
              requestGenerator: requestGenerator)
  }

}

/// Mutable structure used only in the creation of the request.
/// This type is sent through the pipes, where they append some customisation to the request.
public struct MutableRequest : RequestGenerator {

  var method: HTTPMethod
  var parameters: Any?
  var headerFields: [String: String]
  var body: Data?
  var queryString: String?
  //    var sslCredentials: SSLCredentials?

  init(method: HTTPMethod) {
    self.method = method
    self.headerFields = [:]
    self.parameters = [:]
  }

  public func httpMethod() -> HTTPMethod {
    return self.method
  }

  public mutating func updateParameters(parameters: Codable?) {
    self.parameters = parameters?.toDictionary
    if let param = parameters?.jsonData {
      self.body = param
      self.updateHTTPHeaderFields(headerFields: [Constants.ContentLength : "\(param.count)"])
    }
  }

  public mutating func updateQueryParameters(parameters: Any?) {
    if let params = parameters as? [String: AnyObject] {
      self.queryString =
        params.urlEncodedQueryStringWithEncoding(encoding: String.Encoding.utf8)
    }
  }

  //    public mutating func updateSSLCredentials(sslCredentials: SSLCredentials) {
  //        self.sslCredentials = sslCredentials
  //    }

  public mutating func updateHTTPHeaderFields(headerFields: [String: String]) {
    self.headerFields += headerFields
  }

}

extension Encodable {
  var toDictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }

  var jsonData: Data? {
    let encoder = JSONEncoder()
    encoder.outputFormatting  = .prettyPrinted
    encoder.keyEncodingStrategy = .convertToSnakeCase
    do {
      return try encoder.encode(self)
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
}
