//
//  Combine+Shim.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 8/12/20.
//

import Foundation

#if !canImport(Combine)
public protocol TopLevelDecoder {
  associatedtype Input
  func decode<T: Decodable>(_ type: T.Type, from: Input) throws -> T
}

public protocol TopLevelEncoder {
  associatedtype Output
  func encode<T: Encodable>(_ value: T) throws -> Output
}
#endif
