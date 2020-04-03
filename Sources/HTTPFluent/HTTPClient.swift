//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

public struct HTTPClient: HTTP & HTTPRequester {
  
  public let baseURL: String
  public let configuration: HTTPRequesterConfiguration
  
  public init(baseURL: String, configuration: HTTPRequesterConfiguration) {
    self.baseURL = baseURL
    self.configuration = configuration
  }
  
  public init(baseURL: String) {
    self.init(baseURL: baseURL, configuration: DefaultHttpClientConfiguration())
  }
  
  public var builder: URLRequestBuilder {
    URLRequestBuilder(self)
  }
  
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public func publisher(forRequest request: URLRequest) -> AnyPublisher<Data, HTTPError> {
    let permittedStatusCodes = configuration.permittedStatusCodes
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { output in
        guard let response = output.response as? HTTPURLResponse else {
          // This will never happen, but it keeps the compiler happy.
          throw HTTPError.unknown
        }
        let statusCode = response.statusCode
        if !permittedStatusCodes.contains(statusCode) {
          throw HTTPError.http(status: statusCode, response: output.data)
        }
        return output.data
      }
      .mapToHTTPError()
      .eraseToAnyPublisher()
  }
  #endif
    
  public func request(_ request: URLRequest, queue: DispatchQueue?, complete: @escaping HTTPResultComplete<Data>) {
    let queue = queue ?? configuration.defaultQueue
    let permittedStatusCodes = configuration.permittedStatusCodes
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      var result: HTTPResult<Data> = .failure(.error(nil))
      defer {
        queue.async {
          complete(result)
        }
      }
      if let error = error {
        result = .failure(.error(error))
        return
      }
      guard let data = data else {
        // This never happens. When there is no data,
        // the "data" parameter is zero-length instead.
        return
      }
      guard let response = response as? HTTPURLResponse else {
        // This will never happen.
        return
      }
      let statusCode = response.statusCode
      if !permittedStatusCodes.contains(statusCode) {
        result = .failure(.http(status: statusCode, response: data))
        return
      }
      result = .success(data)
    }
    task.resume()
  }
}

private struct DefaultHttpClientConfiguration: HTTPRequesterConfiguration {
  let permittedStatusCodes = Array(200..<205)
  let defaultQueue = DispatchQueue.global()
  let defaultHeaders: [String: String] = [:]
}
