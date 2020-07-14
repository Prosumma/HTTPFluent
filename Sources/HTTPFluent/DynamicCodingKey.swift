//
//  DynamicCodingKey.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 5/13/20.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

/// A dynamic _ad hoc_ `CodingKey`, backed by a `String`.
public struct DynamicCodingKey: CodingKey, ExpressibleByStringLiteral {
  public let intValue: Int? = nil
  public let stringValue: String

  public init?(intValue: Int) {
    nil
  }

  public init?(stringValue: String) {
    self.stringValue = stringValue
  }

  public init(stringLiteral value: String) {
    stringValue = value
  }
}
