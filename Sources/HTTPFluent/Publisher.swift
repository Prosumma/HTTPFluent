//
//  Publisher.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 7/13/20.
//

import Combine

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
