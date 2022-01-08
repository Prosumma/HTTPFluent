//
//  HTTPHeaderField.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

/**
 Represents an HTTP header field.

 Instances may be initialized with a string literal, e.g.,
 `let accept: HTTPHeaderField = "Accept"`.
 */
public struct HTTPHeaderField: ConstantValue {
  public let rawValue: String
  public init(constantValue value: String) {
    rawValue = value
  }
}

public extension HTTPHeaderField {
  static let accept: HTTPHeaderField = "Accept"
  static let authorization: HTTPHeaderField = "Authorization"
  static let contentType: HTTPHeaderField = "Content-Type"
  static let language: HTTPHeaderField = "Accept-Language"
}
