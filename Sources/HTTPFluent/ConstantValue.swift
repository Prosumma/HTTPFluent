//
//  ConstantValue.swift
//  HttpFluent
//
//  Created by Gregory Higley on 2020-07-18.
//

import Foundation

public protocol ConstantValue: RawRepresentable & Hashable & ExpressibleByStringLiteral & CustomStringConvertible {
  var caseInsensitiveRawValue: RawValue { get }
}

public extension ConstantValue where RawValue == String {
  var caseInsensitiveRawValue: String {
    rawValue
  }
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.caseInsensitiveRawValue == rhs.caseInsensitiveRawValue
  }
  
  init(stringLiteral value: String) {
    self.init(rawValue: value)!
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(caseInsensitiveRawValue)
  }
  
  var description: String {
    rawValue
  }
}
