//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

public extension HTTP {
  private func patch(_ encode: @escaping HTTPEncode) -> Builder {
    body(encode).method(.patch)
  }
  
  func patch(data: Data) -> Builder {
    patch { data }
  }
  
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func patch<Body: Encodable, Encoder: TopLevelEncoder>(body: Body, encoder: Encoder) -> Builder where Encoder.Output == Data {
    patch { try encoder.encode(body) }
  }
  #endif
  
  func patch<JSON: Encodable>(json: JSON, encoder: JSONEncoder = JSONEncoder()) -> Builder {
    content(type: .json).patch { try encoder.encode(json) }
  }
  
  func patch(form: FormData) -> Builder {
    content(type: form.contentType).patch(data: form.encode())
  }
}

