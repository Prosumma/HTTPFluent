//
//  Http.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

import Foundation

public protocol HTTP {
  var builder: URLRequestBuilder { get }
}

private extension CharacterSet {
  static let urlPathSegmentAllowed = CharacterSet.urlPathAllowed.subtracting(CharacterSet(charactersIn: "/"))
}

private extension String {
  var urlPathSegmentEncoded: String {
    addingPercentEncoding(withAllowedCharacters: .urlPathSegmentAllowed)!
  }
}

public extension HTTP {
  internal func build<Value>(_ keyPath: WritableKeyPath<URLRequestBuilder, Value>, _ value: Value) -> URLRequestBuilder {
    var b = builder
    b[keyPath: keyPath] = value
    return b
  }
  
  func method(_ method: HTTPMethod) -> URLRequestBuilder {
    build(\.method, method)
  }
  
  func path(escaped path: String) -> URLRequestBuilder {
    build(\.escapedPath, path)
  }
  
  func path(_ path: String) -> URLRequestBuilder {
    build(\.escapedPath, path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
  }

  func path(_ segments: Any...) -> URLRequestBuilder {
    path(escaped: segments.map { "\($0)".urlPathSegmentEncoded }.joined(separator: "/"))
  }
  
  func query(_ value: Any, forName name: String) -> URLRequestBuilder {
    build(\.query[name], value)
  }

}
