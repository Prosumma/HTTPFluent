//
//  HTTPClientProtocol+Combine.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 5/14/20.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Combine
import Foundation

//swiftlint:disable function_default_parameter_at_end
public extension HTTPClientProtocol {
  /// Returns a publisher that wraps a URL session data task for a given URL request and decode the response with the specified decoder.
  ///
  /// The publisher publishes Reponse when the task completes, or terminates if the task fails with an error.
  /// - Parameters:
  ///   - type: The type to decode
  ///   - decoder: The json decoder to decode data to Response
  /// - Returns: A publisher that wraps a data task for the URL request.
  func publisher<Response, Decoder>(
    decoding type: Response.Type = Response.self,
    decoder: Decoder
  ) -> AnyPublisher<Response, HTTPError> where Response: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
    publisher.decode(type: type, decoder: decoder).mapErrorIfNeeded(HTTPError.decoding).eraseToAnyPublisher()
  }

  /// Returns a publisher that wraps a URL session data task for a given URL request and decode the response with JSONDecoder.
  ///
  /// - Parameter type: The type to decode
  /// - Returns: A publisher that wraps a data task for the URL request.
  func publisher<Response: Decodable>(
    decoding type: Response.Type = Response.self
  ) -> AnyPublisher<Response, HTTPError> {
    accept(.json).publisher(decoding: type, decoder: JSONDecoder())
  }

  func stringPublisher(encoding: String.Encoding = .utf8) -> AnyPublisher<String, HTTPError> {
    return publisher.tryMap { data in
      guard let string = String(data: data, encoding: encoding) else {
        throw HTTPError.decoding(nil)
      }
      return string
    }
    .mapToHttpError
    .eraseToAnyPublisher()
  }
}
