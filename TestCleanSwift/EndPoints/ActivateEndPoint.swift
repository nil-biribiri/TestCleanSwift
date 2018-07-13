//
//  ActivateEndPoint.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 2/7/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import NilNetzwerk

enum ActivateEndPoint {
  case activate
}

extension ActivateEndPoint: ServiceEndpoint {

  var baseURL: URL {
    return URL(string: "https://api.weomni-test.com")!
  }

  var method: HTTPMethod {
    return .POST
  }

  var path: String {
    return "/v1/terminals/activate"
  }

  var parameters: Codable? {
    return EDCActivateRequest(activationCode:"00000046",
                              imei: "596A19A6-F",
                              latitude: 13.774509378684309,
                              longitude: 100.64252445261097,
                              password: "1111")
  }

}

public class EDCActivateRequest: Codable {
  var activationCode  : String
  var imei            : String
  var latitude        : Double
  var longitude       : Double
  var password        : String

  /**
   Initializes EDCActivateRequest with default settings.
   - parameter activationCode: EDC activation code.
   - parameter imei: Device's IMEI.
   - parameter latitude: Device's lattitude.
   - parameter longitude: Device's longitude.
   - parameter password: EDC password (Pincode).
   */
  public init(activationCode: String,
              imei: String,
              latitude: Double,
              longitude: Double,
              password: String) {
    self.activationCode = activationCode
    self.imei           = imei
    self.latitude       = latitude
    self.longitude      = longitude
    self.password       = password
  }
}


public class EDCActivateResponse: Codable {
  public var serialNumber    : String?
  public var activationCode  : String?
  public var brandId         : String?
  public var branchId        : String?
  public var terminalId      : String?
}

