//
//  MimeType.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

//swiftlint:disable type_contents_order

/**
 Represents a mime type.

 Instances may be initialized with a string literal, e.g.,
 `let html: MimeType = "text/html"`.
 */
public struct MimeType: ConstantValue {
  public let rawValue: String

  public init?(rawValue: String) {
    self.rawValue = rawValue
  }
}

public extension MimeType {
  static let formData: MimeType = "multipart/form-data"
  static let html: MimeType = "text/html"
  static let jpeg: MimeType = "image/jpeg"
  static let json: MimeType = "application/json"
  static let png: MimeType = "image/png"
  static let text: MimeType = "text/plain"
  static let urlEncoded: MimeType = "application/x-www-form-urlencoded"
}
