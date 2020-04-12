//
//  HTTPRequester.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  /// Maps any error to `HTTPError`
  func mapToHttpError() -> Publishers.MapError<Self, HTTPError> {
    mapError { e in
      switch e {
      case let e as HTTPError: return e
      default: return HTTPError.error(e)
      }
    }
  }
}
#endif

/**
 The protocol for a type responsible for
 making an HTTP request.
 */
public protocol HTTPRequester {
  /**
   Make an HTTP request using the given parameters.
   
   - parameter request: The `URLRequest` used to make the request.
   - parameter configuration: The `HTTPConfiguration` used for the request. See the documentation on `HTTPConfiguration`.
   - parameter queue: The `DispatchQueue` on which the `complete` callback will always occur.
   - parameter complete: The callback made after completion of the request.
   */
  func request(_ request: URLRequest, configuration: HTTPConfiguration, queue: DispatchQueue, complete: @escaping HTTPResultComplete<Data>)

#if canImport(Combine)

  /**
   A `Combine` publisher for the specified `URLRequest` and `HTTPConfiguration`.
   
   - note: Since there is no callback when using a publisher, any configured `DispatchQueue`
   will be ignored. Of course, `Combine`'s scheduler mechanism is always available.
   
   - parameter request: The `URLRequest` to be made.
   - parameter configuration: The `HTTPConfiguration` with which to make the request.
   */
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func publisher(forRequest request: URLRequest, configuration: HTTPConfiguration) -> AnyPublisher<Data, HTTPError>

#endif
}

#if swift(>=5.2)

public extension HTTPRequester {
  /**
   Make an HTTP request using the given parameters.
   
   - note: An `HTTPRequester` implements the "command" pattern. It does only one thing: Make an HTTP request.
   It is thus a perfect candidate for [Swift's new "callAsFunction" language feature](https://github.com/apple/swift-evolution/blob/master/proposals/0253-callable.md).
   
   - parameter request: The `URLRequest` used to make the request.
   - parameter configuration: The `HTTPConfiguration` used for the request. See the documentation on `HTTPConfiguration`.
   - parameter queue: The `DispatchQueue` on which the `complete` callback will always occur.
   - parameter complete: The callback made after completion of the request.
   */
  func callAsFunction(_ request: URLRequest, configuration: HTTPConfiguration, queue: DispatchQueue, complete: @escaping HTTPResultComplete<Data>) {
    self.request(request, configuration: configuration, queue: queue, complete: complete)
  }
}

#endif

public struct DefaultHTTPRequester: HTTPRequester {
  public init() {}

  public func request(_ request: URLRequest, configuration: HTTPConfiguration, queue: DispatchQueue, complete: @escaping HTTPResultComplete<Data>) {
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      var result: HTTPResult<Data> = .failure(.unknown)
      defer {
        queue.async {
          complete(result)
        }
      }
      if let error = error {
        result = .failure(.error(error))
        return
      }
      guard let response = response as? HTTPURLResponse, let data = data else {
        return
      }
      do {
        try configuration.permit(response: response, data: data)
        result = .success(data)
      } catch let e as HTTPError {
        result = .failure(e)
      } catch {
        result = .failure(.error(error))
      }
    }
    task.resume()
  }

#if canImport(Combine)

  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public func publisher(forRequest request: URLRequest, configuration: HTTPConfiguration) -> AnyPublisher<Data, HTTPError> {
    URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
      guard let response = response as? HTTPURLResponse else {
        throw HTTPError.unknown
      }
      try configuration.permit(response: response, data: data)
      return data
    }
    .mapToHttpError()
    .eraseToAnyPublisher()
  }

#endif
}
