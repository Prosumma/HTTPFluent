//
//  Publisher.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 7/13/20.
//

#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  
  func mapErrorIfNeeded<E>(_ transformError: @escaping (Failure) -> E) -> Publishers.MapError<Self, E> {
    mapError { error in
      switch error {
      case let error as E: return error
      default: return transformError(error)
      }
    }
  }

  var mapToURLError: Publishers.MapError<Self, URLError> {
    return mapErrorIfNeeded(URLError.error)
  }
  
}
#endif
