//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

public struct HTTPMethod: RawRepresentable & ExpressibleByStringLiteral {
  public let rawValue: String
  
  public init?(rawValue: String) {
    self.rawValue = rawValue.uppercased()
  }
  
  public init(stringLiteral value: StringLiteralType) {
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
