//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/5/20.
//

#if canImport(Combine)
import Combine
import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension HTTP {
  var publisher: AnyPublisher<Output, HTTPError> {
    let b = builder
    return b.request.publisher.flatMap(b.client.publisher(forRequest:)).tryMap(b._decode).mapToHttpError().eraseToAnyPublisher()
  }
}

#endif
