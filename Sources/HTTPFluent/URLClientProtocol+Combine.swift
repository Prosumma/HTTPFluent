//
//  URLClientProtocol+Combine.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-08-12.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import Foundation

public extension URLClientProtocol {
  /**
   Decodes the `Data` in the published stream using `decode`.
   
   The `decode` function is very general. It simply maps from
   `Data` to the desired type, throwing an `Error` if this fails.
   It can be used to map from `Data` to `String`, for instance.
   The `Decoders` type has static members which can be used for
   this purpose, e.g.,
   
   ```swift
   let publisher = fluent.publisher(decode: Decoders.string)
   ```
   
   `Decoders.string` is a function which decodes from `Data`
   to `String`, assuming the underlying `Data` is UTF-8.
   */
  func receivePublisher<Response>(
    decode: @escaping Decoders.Decode<Response>
  ) -> AnyPublisher<Response, URLError> {
    receivePublisher.tryMap(decode).mapErrorIfNeeded(URLError.decoding).eraseToAnyPublisher()
  }
  
  /**
   Decodes the `Data` in the published stream using the given `decoder`, which
   must be of type `TopLevelDecoder`.
   
   If `decoder` is `JSONDecoder`, the `Accept: application/json` is sent
   automatically with the request.
   */
  func receivePublisher<Response, Decoder: Sendable>(
    decoding type: Response.Type = Response.self,
    decoder: Decoder
  ) -> AnyPublisher<Response, URLError> where Response: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
    let fluent = decoder is JSONDecoder ? accept(.json) : self
    return fluent.receivePublisher(decode: Decoders.decode(type, with: decoder))
  }

  /// Decodes the `Data` in the published stream using a default `JSONDecoder`.
  func receivePublisher<Response: Decodable>(
    json type: Response.Type = Response.self
  ) -> AnyPublisher<Response, URLError> {
    accept(.json).receivePublisher(decode: Decoders.json(type))
  }

}
