//
//  HTTPMethod.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

/**
 Represents the HTTP method of a request.

 Instances may be initialized with a string literal, e.g.,
 `let put: HTTPMethod = "PUT"`.
 */
public struct HTTPMethod: ConstantValue {
  public let rawValue: String
  public init(constantValue value: String) {
    rawValue = value
  }
}

public extension HTTPMethod {
  static let connect: HTTPMethod = "CONNECT"
  static let delete: HTTPMethod = "DELETE"
  static let get: HTTPMethod = "GET"
  static let options: HTTPMethod = "OPTIONS"
  static let patch: HTTPMethod = "PATCH"
  static let post: HTTPMethod = "POST"
  static let put: HTTPMethod = "PUT"
}
