//
//  URLClientProtocol+Async.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2021-12-25.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import Foundation

public extension URLClientProtocol {
  func receive<Response>(decode: @escaping Decoders.Decode<Response>) async throws -> Response {
    try decode(await receive())
  }

  func receive<Response, Decoder: Sendable>(
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
