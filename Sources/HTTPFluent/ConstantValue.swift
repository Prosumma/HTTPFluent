//
//  ConstantValue.swift
//  HttpFluent
//
//  Created by Gregory Higley on 2020-07-18.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

public protocol ConstantValue: RawRepresentable & Hashable & ExpressibleByStringLiteral & CustomStringConvertible where RawValue == String {
  init(constantValue value: String)
}

public extension ConstantValue {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.rawValue.caseInsensitiveCompare(rhs.rawValue) == .orderedSame
  }
    
  init(stringLiteral value: String) {
    self.init(constantValue: value)
  }

  init?(rawValue: String) {
    self.init(constantValue: rawValue)
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue.uppercased())
  }
  
  var description: String {
    rawValue
  }
}
