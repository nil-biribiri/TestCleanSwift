//
//  EDCClient.swift
//  edcsdk
//
//  Created by Tanasak.Nge on 17/3/2561 BE.
//  Copyright © 2561 EGG Digital. All rights reserved.
//

import Foundation
import UIKit

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

final private class EDCClientSession {
  static let shared: URLSession = {
    let configuration                           = URLSessionConfiguration.default
    configuration.requestCachePolicy            = .reloadIgnoringLocalAndRemoteCacheData
    configuration.timeoutIntervalForRequest     = 30
    configuration.timeoutIntervalForResource    = 30
    configuration.urlCache                      = nil
    
    return URLSession(configuration: configuration)
  }()
}

//public typealias RequestRetryCompletion = () -> Void

final class NetworkClient {
//  private static var requestsToRetry: Queue<RequestRetryCompletion> = Queue()
  private static var isRefreshToken: Bool = false
  
  class func request<_Param: Codable, _Result: Codable>(url: String? = nil,
                                                        urlRequest: URLRequest? = nil,
                                                        params: _Param?,
                                                        paramsType: _Param.Type,
                                                        method: HTTPMethod,
                                                        headers: [String: String]? = nil,
                                                        resultType: _Result.Type,
                                                        completion : @escaping (Result<(_Result)>) -> Void) {
    
    if url == nil && urlRequest == nil {
      return completion(Result.failure(NetworkServiceError.urlError))
    }
    
//    if isRefreshToken && urlRequest?.url?.absoluteString != API.Token.getTokenAPI {
//      // enqueue retry request
//      EDCClient.requestsToRetry.enqueue {
//        EDCClient.request(url: url, urlRequest: urlRequest, params: params, paramsType: paramsType, method: method, headers: headers, resultType: resultType, completion: completion)
//      }
//      return
//    }
    
    var request: URLRequest?
    
    if let urlString = url, var url = URL(string: urlString) {
      if method == .get, let params = params {
        buildQueryURL(url: &url, params: params)
      }
      request = URLRequest(url: url)
      buildRequestHeader(request: &request!, headers: headers)
    } else if let urlRequest = urlRequest {
      request = urlRequest
    }
    
    guard var checkedRequest = request else {
      return completion(Result.failure(NetworkServiceError.urlError))
    }
    
    checkedRequest.httpMethod = method.rawValue
    print("Request URL: \(checkedRequest.url!)")
    print("Request Headers: \(checkedRequest.allHTTPHeaderFields! as AnyObject)")
    
    if method != .get {
      let encoder = JSONEncoder()
      encoder.outputFormatting  = .prettyPrinted
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let paramData = try? encoder.encode(params)
      if let param = paramData {
        checkedRequest.httpBody = paramData
        print("Request Body: \(String(decoding: param, as: UTF8.self))")
      }
    }
    
    DispatchQueue.main.async {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    EDCClientSession.shared.dataTask(with: checkedRequest) { (data, response, error) in
      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
      
      if let data = data,
        let json  = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
        let logJson = json {
        print("Response: \(logJson.prettyPrint())")
      }
      
      if let error = error {
        let errorCode = (error as NSError).code
        switch errorCode {
        case -1001:
          return completion(Result.failure(NetworkServiceError.connectionTimeout(message: error.localizedDescription)))
        case -1009:
          return completion(Result.failure(NetworkServiceError.noInternetConnection(message: error.localizedDescription)))
        default:
          return completion(Result.failure(NetworkServiceError.unknownError(message: error.localizedDescription)))
        }
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        return completion(Result.failure(NetworkServiceError.unknownError(message: "No error and response.")))
      }
      
      switch httpResponse.statusCode {
      case 200..<300:
        do {
          // Decode result to object
          let jsonDecoder = JSONDecoder()
          jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
          if let data  = data {
            let result  = try jsonDecoder.decode(_Result.self, from: data)
            return completion(Result.success(result))
          }
        } catch let error {
          // parseJSON Error
          let decodingError = error as? DecodingError
          return completion(Result.failure(NetworkServiceError.parseJSONError(resultType: String(describing: _Result.self),
                                                                          message: decodingError.debugDescription)))
        }
//      case 401:
//        // enqueue retry request
//        EDCClient.requestsToRetry.enqueue {
//          EDCClient.request(url: url, urlRequest: urlRequest, params: params, paramsType: paramsType, method: method, headers: headers, resultType: resultType, completion: completion)
//        }
//        // cancel all previous tasks
//        EDCClientSession.shared.getAllTasks(completionHandler: { (allTasks) in
//          allTasks.forEach{ $0.cancel() }
//        })
//        EDCClient.isRefreshToken = true
//        // call get token (oauth)
//        GetTokenService.callGetTokenService(completion: { (_) in
//          EDCClient.isRefreshToken = false
//          while EDCClient.requestsToRetry.count != 0 {
//            EDCClient.requestsToRetry.dequeue()!()
//          }
//        })
      default:
        let errorMessage = "Unknown Error."
        if let data  = data {
          let logJson  = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
          if let errorMessageFromPayload = getErrorFromPayload(json: logJson){
            // Error message found in payload
            let displayCode = (errorMessageFromPayload.first ?? String(httpResponse.statusCode)) ?? String(httpResponse.statusCode)
            let message     = (errorMessageFromPayload.last ??  errorMessage) ?? errorMessage
            return completion(Result.failure(NetworkServiceError.receiveErrorFromService(statusCode: httpResponse.statusCode,
                                                                                     displayCode: displayCode,
                                                                                     message: message)))
          }
        }
        return completion(Result.failure(NetworkServiceError.cannotGetErrorMessage))
      }
      }.resume()
  }
}

extension NetworkClient {
  
  private static func buildRequestHeader(request: inout URLRequest, headers: [String: String]?) {
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("\(EDCTokenResponse.shared.tokenType) \(EDCTokenResponse.shared.accessToken)", forHTTPHeaderField: "Authorization")
    headers?.forEach {
      request.addValue($0.value, forHTTPHeaderField: $0.key)
    }
  }
  
  private static func buildQueryURL<_Param: Codable>(url: inout URL, params: _Param) {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    var queryItems = [URLQueryItem]()
    params.dictionary?.forEach{ queryItems.append(URLQueryItem(name: $0.key.snakeCased(),
                                                               value: $0.value as? String )) }
    urlComponents?.queryItems = queryItems
    if let urlWithQuery = urlComponents?.url {
      url = urlWithQuery
    }
  }
  
  private static func getErrorFromPayload(json: [String:AnyObject]??) -> [String?]? {
    guard let serializeJSON = json, let convertedJSON = serializeJSON else {
      return nil
    }
    if let statusCode = convertedJSON["status_code"],
      let statusMessage = convertedJSON["status_message"] {
      return [statusCode as? String, statusMessage as? String]
    }
//    if let errorBody = convertedJSON["status"], let error = errorBody as? [String:Any] {
//      return [error["message"] as? String]
//    }
//    if let errorBody = convertedJSON["error"], let error = errorBody as? [String: Any] {
//      return [error["display_code"] as? String, error["message"] as? String]
//    }
    return nil
  }
  
}
