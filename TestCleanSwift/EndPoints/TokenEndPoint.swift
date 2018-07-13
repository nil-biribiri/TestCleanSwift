//
//  TokenEndPoint.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 2/7/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import NilNetzwerk

struct TokenRequestGenerator: RequestGenerator {
  func generateRequest(withMethod method: HTTPMethod) -> MutableRequest {
    return request(withMethod: method) |> withBasicAuth
  }

  var authUserName: String? {
    return "j7BMIiZg00loIx6RIztodwfiroYq0x7F"
  }

  var authPassword: String? {
    return "k0LdyNWpusGXDZbZ"
  }
  
}

enum TokenEndPoint {
  case getToken
}

extension TokenEndPoint: ServiceEndpoint {

  var baseURL: URL {
    return URL(string: "https://api.weomni-test.com")!
  }

  var method: HTTPMethod {
    return .POST
  }

  var path: String {
    return "/oauth/token"
  }

  var requestGenerator: RequestGenerator {
    get {
      return TokenRequestGenerator()
    }
  }

  var parameters: Codable? {
    return GrantType()
  }


}

struct TokenResponse: Codable {
  static var shared = TokenResponse(tokenType: "", accessToken: "")

  let tokenType: String
  let accessToken: String

  enum CodingKeys: String, CodingKey {
    case tokenType = "token_type"
    case accessToken = "access_token"
  }

}

struct GrantType: Codable {
  let grantType: String = "client_credentials"

  enum CodingKeys: String, CodingKey {
    case grantType = "grant_type"
  }

}
