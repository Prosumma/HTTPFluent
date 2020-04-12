//
//  HTTPConfiguration.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

import Foundation

/**
 An implementation of this protocol may be passed to
 `HTTPClient` to configure certain aspects of the
 request, such as permitted status codes, default
 HTTP headers, and the default queue on which
 the completion callback occurs.
 */
public protocol HTTPConfiguration {
  /// The `Set` of permitted status codes, which defaults
  /// to `200`, `201`, `202`, `203`, `204`, `205`.
  var permittedStatusCodes: Set<Int> { get }

  /**
   Implement this function to have complete control
   over an HTTP response. The default implementation
   simply checks the `statusCode` property of the
   response against the `permittedStatusCodes` property
   of the `HTTPConfiguration`.
   */
  func permit(response: HTTPURLResponse, data: Data) throws

  /// The default queue on which the HTTP
  /// completion callback will be called.
  var defaultQueue: DispatchQueue { get }

  /// The default headers for the HTTP request.
  var defaultHeaders: [String: String] { get }

  /**
   Returns a decoder registered for the requested
   type. `DefaultHTTPConfiguration` registers a
   decoder only for `String`. This decoder takes
   the `Data` of the request, assumes it is
   encoded as UTF-8, and attempts to decode it
   to a `String`.
   
   In the fluent interface, this function is used
   inside the `decode<T>(T)` method, e.g.,
   
   ```
   http.decode(String.self).request { result in
     // handle the result
   }
   ```
   */
  subscript<T>(type: T.Type) -> HTTPDecode<T>? { get }
}

/**
 The defaul implementation of `HTTPConfiguration`. It
 is slightly easier to subclass this than to provide
 your own implementation.
 
 If an instance of `HTTPConfiguration` is not passed
 to `HTTPClient`, an instance of `DefaultHTTPConfiguration`
 will be used.
 */
open class DefaultHTTPConfiguration: HTTPConfiguration {
  public init() {}
  open var permittedStatusCodes: Set<Int> {
    return Set(200..<206)
  }
  open func permit(response: HTTPURLResponse, data: Data) throws {
    if !permittedStatusCodes.contains(response.statusCode) {
      throw HTTPError.http(response: response, data: data)
    }
  }
  open var defaultQueue: DispatchQueue {
    return .global()
  }
  open var defaultHeaders: [String: String] {
    return [:]
  }
  open subscript<T>(type: T.Type) -> HTTPDecode<T>? {
    if type == String.self {
      return { data in
        guard let string = String(data: data, encoding: .utf8) as? T else {
          throw HTTPError.decoding(nil)
        }
        return string
      }
    }
    return nil
  }
}
