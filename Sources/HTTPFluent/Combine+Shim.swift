//
//  Combine+Shim.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-08-12.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
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
