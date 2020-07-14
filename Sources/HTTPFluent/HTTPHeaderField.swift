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
public struct HTTPHeaderField: RawRepresentable & ExpressibleByStringLiteral {
  public let rawValue: String

  public init?(rawValue: String) {
    self.rawValue = rawValue.uppercased()
  }

  public init(stringLiteral value: String) {
    //swiftlint:disable:next force_unwrapping
    self.init(rawValue: value)!
  }
}

public extension HTTPHeaderField {
  static let accept: HTTPHeaderField = "Accept"
  static let authorization: HTTPHeaderField = "Authorization"
  static let contentType: HTTPHeaderField = "Content-Type"
  static let language: HTTPHeaderField = "Accept-Language"
}
