//
//  URLClientProtocol+Async.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2021-12-25.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

#if canImport(Combine)
import Combine
#endif

#if swift(>=5.5)

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension URLClientProtocol {
  func receive<Response>(decode: @escaping Decoders.Decode<Response>) async throws -> Response {
    try decode(await receive())
  }

  func receive<Response, Decoder>(
    decoding type: Response.Type = Response.self,
    decoder: Decoder
  ) async throws -> Response where Response: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
    try await receive(decode: Decoders.decode(type, with: decoder))
  }

  func receive<Response: Decodable>(
    json type: Response.Type
  ) async throws -> Response {
    try await receive(decode: Decoders.json(type))
  }
}

#endif
