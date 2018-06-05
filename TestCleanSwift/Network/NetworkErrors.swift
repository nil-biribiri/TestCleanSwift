//
//  NetworkErrors.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 5/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
  case receiveErrorFromService(statusCode: Int, displayCode: String,  message: String)
  case unknownError(message: String)
  case urlError
  case noInternetConnection(message: String)
  case parseJSONError(resultType: String, message: String)
  case cannotGetErrorMessage
  case connectionTimeout(message: String)
}

