//
//  HTTP.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

/**
 The `HTTP` protocol is the foundation on which
 the fluent interface is built.
 */
public protocol HTTP {
  /**
   The output type of the fluent interface.
   
   When making an HTTP request, we want to get something
   back in the body of the request. This is either `Data`
   or something which can be decoded from `Data`. The
   default is `Data`, because we always start there.
   */
  associatedtype Output = Data

  /**
   HTTP calls can fail. The `Wrapper` contains either
   an instance of the `Output` or an `HTTPError`.
   */
  associatedtype Wrapper: OutputWrapper where Wrapper.Output == Output

  /// A convenient type alias
  typealias Builder = URLRequestBuilder<Wrapper>

  /**
   Returns the `URLRequestBuilder` instance containing the
   state for the fluent interface.
   */
  var builder: Builder { get }
}

public extension HTTP {
  internal func build<Value>(_ keyPath: WritableKeyPath<Builder, Value>, _ value: Value) -> Builder {
    var b = builder
    b[keyPath: keyPath] = value
    return b
  }

  /// Sets the HTTP method for the request.
  func method(_ method: HTTPMethod) -> Builder {
    build(\._method, method)
  }

  /**
   Sets a function which encodes the HTTP body to
   `Data`.
   
   Why a function? Encoding the body of the request
   to `Data` is deferred until the request is actually
   made.
   */
  func body(_ encode: @escaping HTTPEncode) -> Builder {
    build(\._encode, encode)
  }

  /// Sets the queue on which the HTTP completion
  /// callback is executed.
  func queue(_ queue: DispatchQueue) -> Builder {
    build(\._queue, queue)
  }
}
