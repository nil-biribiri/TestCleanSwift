//
//  NetworkClient.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 30/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case options = "OPTIONS"
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
}

final private class NetworkClientSession {
  static let shared: URLSession = {
    
    let configuration                           = URLSessionConfiguration.default
    configuration.requestCachePolicy            = .reloadIgnoringLocalAndRemoteCacheData
    configuration.timeoutIntervalForRequest     = 30
    configuration.timeoutIntervalForResource    = 30
    configuration.urlCache                      = nil
    
    return URLSession(configuration: configuration)
  }()
}

final class NetworkClient {
  class func request<_Param: Codable, _Result: Codable>(url: String,
                                                        params: _Param?,
                                                        paramsType: _Param.Type,
                                                        method: HTTPMethod,
                                                        headers: [String: String]? = nil,
                                                        resultType: _Result.Type,
                                                        completion : @escaping (Result<(_Result)>) -> Void) {
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    let urlString = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard var url = URL(string: urlString) else {
      return
    }
    
//    if method == .get, let params = params {
//      buildQueryURL(url: &url, params: params)
//    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    print("Request URL: \(request.url!)")
    
    buildRequestHeader(request: &request, headers: headers)
    print("Request Headers: \(request.allHTTPHeaderFields! as AnyObject)")
    
    if method != .get {
      let encoder = JSONEncoder()
      encoder.outputFormatting    = .prettyPrinted
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let paramData               = try? encoder.encode(params)
      request.httpBody            = paramData
      if let param = paramData {
        print("Request Body: \(String(decoding: param, as: UTF8.self))")
      }
    }
    
    NetworkClientSession.shared.dataTask(with: request) { (data, response, error) in
      if let data = data {
        print("Response: \(String(decoding: data, as: UTF8.self))")
      }
      
      
//      if let error = error  {
//        let errorCode = (error as NSError).code
//        switch errorCode {
//        case -1001:
//          return completion(Result.failure(EDCServiceError.connectionTimeout(message: error.localizedDescription)))
//        case -1009:
//          return completion(Result.failure(EDCServiceError.noInternetConnection(message: error.localizedDescription)))
//        default:
//          return completion(Result.failure(EDCServiceError.unknownError(message: error.localizedDescription)))
//        }
//      }
//
      guard let httpResponse = response as? HTTPURLResponse else {
//        return completion(Result.failure(EDCServiceError.unknownError(message: "No error and response.")))
        return
      }
      
      switch httpResponse.statusCode {
      case 200..<300:
        do {
          // Decode result to object
          let jsonDecoder                 = JSONDecoder()
          jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
          if let data     = data {
            let result  = try jsonDecoder.decode(_Result.self, from: data)
            DispatchQueue.main.async {
              return completion(Result.success(result))
            }
          }
        } catch let error {
          // parseJSON Error
          let decodingError       = error as? DecodingError
//          return completion(Result.failure(EDCServiceError.parseJSONError(resultType: String(describing: _Result.self),
//                                                                          message: decodingError.debugDescription)))
        }
        
      default:
        return
//        let errorMessage = "Unknown Error."
//        if let data  = data {
//          let logJson     = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//          if let errorMessageFromPayload =  getErrorFromPayload(json: logJson){
//            // Error message found in payload
//            let displayCode = (errorMessageFromPayload.first ?? String(httpResponse.statusCode)) ?? String(httpResponse.statusCode)
//            let message     = (errorMessageFromPayload.last ??  errorMessage) ?? errorMessage
//            return completion(Result.failure(EDCServiceError.receiveErrorFromService(statusCode: httpResponse.statusCode,
//                                                                                     displayCode: displayCode,
//                                                                                     message: message)))
//          }
//        }
//        return completion(Result.failure(EDCServiceError.cannotGetErrorMessage))
      }
      }.resume()
  }
  
}

extension NetworkClient {
  
  private static func buildRequestHeader(request: inout URLRequest, headers: [String: String]?) {
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    if let encryptValue = encryptRSA() {
//      request.addValue(encryptValue, forHTTPHeaderField: "X-Signature")
//    }
    headers?.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }
  }
  
//  private static func buildQueryURL<_Param: Codable>(url: inout URL, params: _Param) {
//    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
//    var queryItems = [URLQueryItem]()
//    params.dictionary?.forEach{ queryItems.append(URLQueryItem(name: $0.key.snakeCased(),
//                                                               value: $0.value as? String )) }
//    urlComponents?.queryItems = queryItems
//    if let urlWithQuery = urlComponents?.url {
//      url = urlWithQuery
//    }
//  }
  
//  private static func encryptRSA() -> String? {
//    let pemFile = Config.environment == .staging ? "public-key" : "public-key-production"
//    if let publicKey    = try? PublicKey(pemNamed: pemFile, in: Config.bundle) {
//      let clear       = try? ClearMessage(string: "eggdigital|\(Date().getTimeStamp())", using: .utf8)
//      if let encrypted   = try? clear?.encrypted(with: publicKey, padding: .PKCS1) {
//        return (encrypted?.base64String) ?? nil
//      }
//      return nil
//    }
//    return nil
//  }
  
//  private static func getErrorFromPayload(json: [String:Any]??) -> [String?]? {
//    guard let serializeJSON = json, let convertedJSON = serializeJSON else {
//      return nil
//    }
//    if let errorBody = convertedJSON["errors"],
//      let errorArr = errorBody as? [[String:Any]],
//      let error = errorArr.first {
//      return [error["message"] as? String]
//    }
//    if let errorBody = convertedJSON["status"], let error = errorBody as? [String:Any] {
//      return [error["message"] as? String]
//    }
//    if let errorBody = convertedJSON["error"], let error = errorBody as? [String: Any] {
//      return [error["display_code"] as? String, error["message"] as? String]
//    }
//    return nil
//  }
  
}

