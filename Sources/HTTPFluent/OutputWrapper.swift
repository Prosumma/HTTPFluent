//
//  OutputWrapper.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

/**
 A type which wraps the `Output` of an
 HTTP request. Implementations exist
 for `Result` and `Optional`.
 */
public protocol OutputWrapper {
  /// The output of the HTTP request.
  associatedtype Output
  /// Create a new instance with an `HTTPError`.
  init(httpError error: HTTPError)
  /// Create a new instance with output.
  init(httpOutput output: Output)
}
