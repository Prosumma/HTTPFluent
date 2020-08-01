//
//  HTTPHeaderField.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

/**
 Represents an HTTP header field.

 Instances may be initialized with a string literal, e.g.,
 `let accept: HTTPHeaderField = "Accept"`.
 */
public struct HTTPHeaderField: ConstantValue {
  public let rawValue: String
  
  public var caseInsensitiveRawValue: String {
    return rawValue.lowercased()
  }

  public init?(rawValue: String) {
    self.rawValue = rawValue
  }
}

public extension HTTPHeaderField {
  static let accept: HTTPHeaderField = "Accept"
  static let authorization: HTTPHeaderField = "Authorization"
  static let contentType: HTTPHeaderField = "Content-Type"
  static let language: HTTPHeaderField = "Accept-Language"
}
