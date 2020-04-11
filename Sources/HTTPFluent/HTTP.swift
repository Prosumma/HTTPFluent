//
//  HTTP.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public protocol HTTP {
  associatedtype Output = Data
  associatedtype Wrapper: OutputWrapper where Wrapper.Output == Output
  typealias Builder = URLRequestBuilder<Wrapper>
  var builder: Builder { get }
}

public extension HTTP {
  func build<Value>(_ keyPath: WritableKeyPath<Builder, Value>, _ value: Value) -> Builder {
    var b = builder
    b[keyPath: keyPath] = value
    return b
  }
  
  func method(_ method: HTTPMethod) -> Builder {
    build(\._method, method)
  }
  
  func body(_ encode: @escaping HTTPEncode) -> Builder {
    build(\._encode, encode)
  }
  
  func queue(_ queue: DispatchQueue) -> Builder {
    build(\._queue, queue)
  }
}

