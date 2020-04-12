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

public protocol HTTPRequester {
  func callAsFunction(_ request: URLRequest, configuration: HTTPConfiguration, queue: DispatchQueue, complete: @escaping HTTPResultComplete<Data>)
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func publisher(forRequest request: URLRequest, configuration: HTTPConfiguration) -> AnyPublisher<Data, HTTPError>
  #endif
}

public struct DefaultHTTPRequester: HTTPRequester {
  public init() {}
  public func callAsFunction(_ request: URLRequest, configuration: HTTPConfiguration, queue: DispatchQueue, complete: @escaping HTTPResultComplete<Data>) {
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
