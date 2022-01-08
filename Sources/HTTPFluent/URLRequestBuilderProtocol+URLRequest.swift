//
//  URLRequestBuilderProtocol+URLRequest.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

public extension URLRequestBuilderProtocol {
  /**
   Sets the HTTP method.

   Note that some other methods, such as `post(json:)`, set
   this implicitly.
   */
  func method(_ method: HTTPMethod) -> Self {
    build(URLRequestBuilder.buildMethod(method.rawValue))
  }

  /// Set an HTTP header
  func header(_ value: String, forField field: HTTPHeaderField) -> Self {
    build(URLRequestBuilder.buildHeader(value, forField: field.rawValue))
  }

  /**
   A convience method for setting the "Content-Type" header.

   Some methods, such as `post(json:)`, set this implicitly.
   */
  func content(type: MimeType, charset: String.Encoding? = nil) -> Self {
    var contentType: String = type.rawValue
    if let charset = charset {
      let enc = CFStringConvertNSStringEncodingToEncoding(charset.rawValue)
      let iana = CFStringConvertEncodingToIANACharSetName(enc) as NSString as String
      contentType += ";charset=\(iana)"
    }
    return header(contentType, forField: .contentType)
  }

  /// A convenience method for setting the "Accept" header.
  func accept(_ mimeType: MimeType) -> Self {
    header(mimeType.rawValue, forField: .accept)
  }

  /// Sets the "Authorization" header
  func authorization(_ authorization: String) -> Self {
    header(authorization, forField: .authorization)
  }

  /// Sets the "Authorization" header with basic authorization
  func authorization(basic: String) -> Self {
    authorization("Basic \(basic)")
  }

  /// Sets a bearer token in the authorization header
  func authorization(bearer token: String) -> Self {
    authorization("Bearer \(token)")
  }

  /// Sets the authorization header for basic authorization
  func authorization(user: String, password: String) -> Self {
    //swiftlint:disable:next force_unwrapping
    let credentials = "\(user):\(password)".data(using: .utf8)!.base64EncodedString()
    return authorization(basic: credentials)
  }
  
  /// Sets the `Accept-Language` header
  func language(_ lang: String) -> Self {
    header(lang, forField: .language)
  }
}
