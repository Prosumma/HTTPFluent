//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import Foundation

private extension CharacterSet {
  static let urlQueryComponentAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&="))
}

private extension String {
  static let crlf = "\r\n"
  var urlQueryComponentEncoded: String {
    addingPercentEncoding(withAllowedCharacters: .urlQueryComponentAllowed)!
  }
}

public struct FormData {

  public enum Encoding {
    case urlEncoded
    case formEncoded
  }

  public struct File {
    public let filename: String
    public let content: String
    public let contentType: String
    public let isBase64Encoded: Bool

    public init(filename: String, content: String, contentType: String) {
      self.filename = filename
      self.content = content
      self.contentType = contentType
      self.isBase64Encoded = false
    }

    public init(filename: String, content: Data, contentType: String) {
      self.filename = filename
      self.content = content.base64EncodedString()
      self.contentType = contentType
      self.isBase64Encoded = true
    }
  }

  public let boundary: String
  public let encoding: Encoding
  private var contents: [String: Any] = [:]

  public init(encoding: Encoding = .formEncoded) {
    self.encoding = encoding
    self.boundary = "----------" + "\(UUID())".replacingOccurrences(of: "-", with: "")
  }

  public subscript(field: String) -> Any? {
    get { contents[field] }
    set { contents[field] = newValue }
  }

  private func formEncode() -> Data {
    var body = ""
    for (field, value) in contents {
      body += .crlf + boundary
      body += .crlf + "Content-Disposition: form-data; name=\"\(field)\""
      if let file = value as? File {
        body += ";filename=\"\(file.filename)\""
        body += .crlf + "Content-Type: \(file.contentType)"
        if file.isBase64Encoded {
          body += .crlf + "Content-Encoding: base64"
        }
        body += .crlf + .crlf + file.content
      } else {
        body += .crlf + .crlf + "\(value)"
      }
    }
    body += .crlf + boundary + "--"
    return body.data(using: .utf8)!
  }

  private func urlEncode() -> Data {
    var entries: [String] = []
    for (field, value) in contents {
      if !(value is File) {
        let entry = field.urlQueryComponentEncoded + "=" + "\(value)".urlQueryComponentEncoded
        entries.append(entry)
      }
    }
    return entries.joined(separator: "&").data(using: .utf8)!
  }

  public func encode() -> Data {
    switch encoding {
    case .formEncoded: return formEncode()
    case .urlEncoded: return urlEncode()
    }
  }
  
  public var contentType: String {
    switch encoding {
    case .formEncoded: return "multipart/form-data;boundary=\"\(boundary)\""
    case .urlEncoded: return "application/x-www-form-urlencoded"
    }
  }
}
