//
//  HTTP+Put.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

public extension HTTP {
  private func put(_ encode: @escaping HTTPEncode) -> Builder {
    body(encode).method(.put)
  }
  
  func put(data: Data) -> Builder {
    put { data }
  }
  
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func put<Body: Encodable, Encoder: TopLevelEncoder>(body: Body, encoder: Encoder) -> Builder where Encoder.Output == Data {
    put { try encoder.encode(body) }
  }
  #endif
  
  func put<JSON: Encodable>(json: JSON, encoder: JSONEncoder = JSONEncoder()) -> Builder {
    content(type: .json).put { try encoder.encode(json) }
  }
  
  func put(form: FormData) -> Builder {
    content(type: form.contentType).put(data: form.encode())
  }
}
