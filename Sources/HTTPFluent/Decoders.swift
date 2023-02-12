//
//  Decoder.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-08-12.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

#if canImport(Combine)
import Combine
#endif
import Foundation

public struct Decoders {
  public typealias Decode<T> = (Data) throws -> T
  
  public static func string(encoding: String.Encoding) -> Decode<String> {
    return { data in
      guard let s = String(data: data, encoding: encoding) else {
        throw URLError.decoding(nil)
      }
      return s
    }
  }

  public static let string: Decode<String> = Self.string(encoding: .utf8)
  
  public static func decode<T: Decodable, Decoder: TopLevelDecoder>(_ type: T.Type, with decoder: Decoder) -> Decode<T> where Decoder.Input == Data {
    return { data in
      do {
        return try decoder.decode(type, from: data)
      } catch {
        throw URLError.decoding(error)
      }
    }
  }
    
  public static func json<T: Decodable>(_ type: T.Type) -> Decode<T> {
    return decode(type, with: JSONDecoder())
  }
}
