//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

public struct HTTPHeaderField: RawRepresentable & ExpressibleByStringLiteral {
  public let rawValue: String
  public init?(rawValue: String) {
    self.rawValue = rawValue
  }
  public init(stringLiteral value: String) {
    self.rawValue = value
  }
  
  public static let accept: HTTPHeaderField = "Accept"
  public static let authorization: HTTPHeaderField = "Authorization"
  public static let contentType: HTTPHeaderField = "Content-Type"
}
