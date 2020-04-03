//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/2/20.
//

import Foundation

public protocol DataEncoder {
  func encode<T>(_ value: T) throws -> Data where T : Encodable
}

extension JSONEncoder: DataEncoder {}

public protocol DataDecoder {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: DataDecoder {}
