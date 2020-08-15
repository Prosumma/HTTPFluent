//
//  URLClientProtocol+Combine.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 8/12/20.
//

#if canImport(Combine)
import Combine
#endif

import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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
  func publisher<Response>(
    decode: @escaping Decoders.Decode<Response>
  ) -> AnyPublisher<Response, URLError> {
    publisher.tryMap(decode).mapErrorIfNeeded(URLError.decoding).eraseToAnyPublisher()
  }
  
  /**
   Decodes the `Data` in the published stream using the given `decoder`, which
   must be of type `TopLevelDecoder`.
   
   If `decoder` is `JSONDecoder`, the `Accept: application/json` is sent
   automatically with the request.
   */
  func publisher<Response, Decoder>(
    decoding type: Response.Type = Response.self,
    decoder: Decoder
  ) -> AnyPublisher<Response, URLError> where Response: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
    let fluent = decoder is JSONDecoder ? accept(.json) : self
    return fluent.publisher(decode: Decoders.decode(type, with: decoder))
  }

  /// Decodes the `Data` in the published stream using a default `JSONDecoder`.
  func publisher<Response: Decodable>(
    json type: Response.Type = Response.self
  ) -> AnyPublisher<Response, URLError> {
    accept(.json).publisher(decode: Decoders.json(type))
  }

}
