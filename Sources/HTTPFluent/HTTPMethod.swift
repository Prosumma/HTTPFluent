//
//  HTTPMethod.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

import Foundation

public struct HTTPMethod: RawRepresentable & ExpressibleByStringLiteral {
  //swiftlint:disable:next force_try
  private static let regex = try! NSRegularExpression(pattern: "^[A-Z]+$", options: .caseInsensitive)
  public let rawValue: String

  public init?(rawValue: String) {
    let range = NSRange(location: 0, length: rawValue.count)
    if nil == Self.regex.firstMatch(in: rawValue, options: [], range: range) {
      return nil
    }
    self.rawValue = rawValue.uppercased()
  }

  public init(stringLiteral value: String) {
    self.init(rawValue: value)!
  }

  public static let connect: HTTPMethod = "CONNECT"
  public static let delete: HTTPMethod = "DELETE"
  public static let get: HTTPMethod = "GET"
  public static let options: HTTPMethod = "OPTIONS"
  public static let patch: HTTPMethod = "PATCH"
  public static let post: HTTPMethod = "POST"
  public static let put: HTTPMethod = "PUT"
}
