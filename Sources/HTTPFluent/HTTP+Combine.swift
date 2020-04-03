//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

#if canImport(Combine)

import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  func mapToHTTPError(_ transform: ((Error) -> HTTPError)? = nil) -> Publishers.MapError<Self, HTTPError> {
    let transform = transform ?? HTTPError.error
    return mapError { e -> HTTPError in
      switch e {
      case let e as HTTPError: return e
      default: return transform(e)
      }
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Output == Data {
  func decodeToString() -> AnyPublisher<String, HTTPError> {
    tryMap { output -> String in
      guard let s = String(data: output, encoding: .utf8) else {
        throw HTTPError.unknown
      }
      return s
    }
    .mapToHTTPError()
    .eraseToAnyPublisher()
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TopLevelDecoder {
  func decode<T: Decodable>(from input: Input) throws -> T {
    try decode(T.self, from: input)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension HTTP {
  var publisher: AnyPublisher<Data, HTTPError> {
    builder.request.publisher.flatMap(builder.requester.publisher(forRequest:)).eraseToAnyPublisher()
  }
  
  func publisher<Response>(decoding type: Response.Type = Response.self, accept: String? = nil, decode: @escaping (Data) throws -> Response) -> AnyPublisher<Response, HTTPError> {
    let b = accept.flatMap(builder.accept) ?? builder
    return b.request.publisher.flatMap(b.requester.publisher(forRequest:)).tryMap(decode).mapToHTTPError().eraseToAnyPublisher()
  }

  func publisher<Response: Decodable, Decoder: TopLevelDecoder>(decoding type: Response.Type = Response.self, decoder: Decoder, accept: String? = nil) -> AnyPublisher<Response, HTTPError> where Decoder.Input == Data {
    publisher(decoding: type, accept: accept, decode: decoder.decode(from:))
  }

  func jsonPublisher<Response: Decodable>(decoding type: Response.Type = Response.self, decoder: JSONDecoder) -> AnyPublisher<Response, HTTPError> {
    publisher(decoding: type, decoder: decoder, accept: .json)
  }
  
  func jsonPublisher<Response: Decodable>(decoding type: Response.Type = Response.self) -> AnyPublisher<Response, HTTPError> {
    publisher(decoding: type, decoder: JSONDecoder(), accept: .json)
  }
  
  var stringPublisher: AnyPublisher<String, HTTPError> {
    publisher(decoding: String.self) { try String(data: $0, encoding: .utf8) ??! HTTPError.decoding(nil) }
  }
}

#endif
