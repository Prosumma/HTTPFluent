//
//  FormData.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-09.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

// swiftlint:disable type_contents_order switch_case_on_newline

/**
 A type that helps to build HTTP form data, either as
 "application/x-www-form-urlencoded" (`FormData.Encoding.urlEncoded`)
 or "multipart/form-data" (`FormData.Encoding.formEncoded`).

 Usage is very straightforward:

 ```swift
 var form = FormData()
 form["x"] = 3
 form["file"] = new FormData.File(filename: "i.jpg", content: data, contentType: .jpeg)
 let data = form.encoded()
 ```
 */
public struct FormData {
  public enum Encoding {
    case urlEncoded
    case formEncoded
  }

  /**
   Represents a file in "multipart/form-data". If the containing
   `FormData` instance is encoded as "application/x-www-form-urlencoded",
   instances of this type are skipped without warning.
   */
  public struct File {
    public let filename: String
    public let content: Data
    public let headers: [String: String]

    public init(filename: String, content: Data, contentType: MimeType, headers: [String: String] = [:]) {
      self.filename = filename
      self.content = content
      self.headers = headers.merging(["Content-Type": contentType.rawValue]) { $1 }
    }
  }

  public let boundary: String
  public var encoding: Encoding
  private var contents: [String: Any] = [:]

  public init(encoding: Encoding = .formEncoded) {
    self.encoding = encoding
    self.boundary = "\(UUID())".replacingOccurrences(of: "-", with: "")
  }

  /**
   Get or set values in the receiver.
   */
  public subscript(field: String) -> Any? {
    get { contents[field] }
    set { contents[field] = newValue }
  }

  private func formEncode() -> Data {
    let boundary = "--" + self.boundary
    var body = Data()
    for (field, value) in contents {
      body.append(.crlf + boundary)
      body.append(.crlf + "Content-Disposition: form-data; name=\"\(field)\"")
      if let file = value as? File {
        body.append(";filename=\"\(file.filename)\"")
        for (header, value) in file.headers {
          body.append(.crlf + "\(header): \(value)")
        }
        body.append(String.crlf + .crlf)
        body.append(file.content)
      } else {
        body.append(.crlf + .crlf + "\(value)")
      }
    }
    body.append(.crlf + boundary + "--")
    return body
  }

  private func urlEncode() -> Data {
    var entries: [String] = []
    for (field, value) in contents where !(value is File) {
      let entry = field.urlQueryComponentEncoded + "=" + "\(value)".urlQueryComponentEncoded
      entries.append(entry)
    }
    //swiftlint:disable:next force_unwrapping
    return entries.joined(separator: "&").data(using: .utf8)!
  }

  /**
   The receiver encoded to `Data`, ready for
   use in the body of an HTTP request.
   */
  public func encoded() -> Data {
    switch encoding {
    case .formEncoded: return formEncode()
    case .urlEncoded: return urlEncode()
    }
  }

  /**
   The content type of the receiver, suitable for use in
   the "Content-Type" header of an HTTP request.
   */
  public var contentType: MimeType {
    switch encoding {
    //swiftlint:disable:next force_unwrapping
    case .formEncoded: return MimeType(rawValue: "\(MimeType.formData);boundary=\"\(boundary)\"")!
    case .urlEncoded: return .urlEncoded
    }
  }
}

private extension Data {
  mutating func append(_ string: String) {
    //swiftlint:disable:next force_unwrapping
    append(string.data(using: .utf8)!)
  }
}

private extension CharacterSet {
  static let urlQueryComponentAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&+="))
}

private extension String {
  static let crlf = "\r\n"
  var urlQueryComponentEncoded: String {
    //swiftlint:disable:next force_unwrapping
    addingPercentEncoding(withAllowedCharacters: .urlQueryComponentAllowed)!
  }
}
