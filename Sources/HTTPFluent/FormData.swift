//
//  FormData.swift
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
    // swiftlint:disable:next force_unwrapping
    addingPercentEncoding(withAllowedCharacters: .urlQueryComponentAllowed)!
  }
}

/**
 A convenient type for encoding HTTP form data
 as either `application/x-www-form-urlencoded` or
 `multipart/form-data`, based on the value of
 `FormData.Encoding` passed to the constructor.
 */
public struct FormData: Collection {
  public typealias Contents = [String: Any]
  public typealias Index = Contents.Index
  public typealias Element = Contents.Element

  /// The encoding to be used in `FormData`.
  public enum Encoding: String {
    case urlEncoded = "application/x-www-form-urlencoded"
    case formEncoded = "multipart/form-data"
  }

  public enum EncodingError: Error {
    case cannotURLEncodeFile
  }

  /**
   A file stored in `multipart/form-data`.
   
   - warning: If the `FormData` instance is encoded as
   `application/x-www-form-urlencoded` and an instance
   of `File` is included, an error will be thrown when
   encoding.
   */
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

  /// The boundary used with `multipart/form-data`.
  public let boundary: String

  /// The encoding to be used: `multipar/form-data` or `application/x-www-form-urlencoded`.
  public var encoding: Encoding

  /// The character encoding to be used. Defaults to UTF-8.
  public var characterEncoding: String.Encoding = .utf8

  /// The named values contained in this instance.
  private var contents: [String: Any] = [:]

  /// Initializes a `FormData` instance with the specified encoding,
  /// which defaults to `FormData.Encoding.formEncoded`.
  public init(encoding: Encoding = .formEncoded) {
    self.encoding = encoding
    self.boundary = "----------" + "\(UUID())".replacingOccurrences(of: "-", with: "")
  }

  /// Gets or sets a named entry in this instance.
  public subscript(field: String) -> Any? {
    get { contents[field] }
    set { contents[field] = newValue }
  }

  private func formEncode() throws -> Data {
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
    return try body.data(using: .utf8) ??! HTTPError.encoding(nil)
  }

  private func urlEncode() throws -> Data {
    var entries: [String] = []
    for (field, value) in contents {
      if value is File {
        throw HTTPError.encoding(EncodingError.cannotURLEncodeFile)
      }
      let entry = field.urlQueryComponentEncoded + "=" + "\(value)".urlQueryComponentEncoded
      entries.append(entry)
    }
    return try entries.joined(separator: "&").data(using: .utf8) ??! HTTPError.encoding(nil)
  }

  /**
   Encode this `FormData` instance to `Data` according
   to whether its content type is `multipart/form-data`
   or `application/x-www-form-url-encoded`.
   
   - warning: For url-encoded data, any `FormData.File` entries
   are skipped.
   */
  public func encode() throws -> Data {
    switch encoding {
    case .formEncoded: return try formEncode()
    case .urlEncoded: return try urlEncode()
    }
  }

  /**
   Returns the content type of this `FormData` instance
   as a mime type string.
   */
  public var contentType: String {
    switch encoding {
    case .formEncoded: return "\(encoding.rawValue);charset=\(characterEncoding.ianaName);boundary=\"\(boundary)\""
    case .urlEncoded: return "\(encoding.rawValue);charset=\(characterEncoding.ianaName)"
    }
  }

  public subscript(position: Index) -> Element {
    contents[position]
  }

  public func index(after i: Index) -> Index {
    contents.index(after: i)
  }

  public var startIndex: Index {
    contents.startIndex
  }

  public var endIndex: Index {
    contents.endIndex
  }
}
