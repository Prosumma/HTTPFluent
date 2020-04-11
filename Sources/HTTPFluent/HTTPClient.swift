//
//  HTTPClient.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

public struct HTTPClient: HTTP {
  public let baseURL: String
  public let configuration: HTTPConfiguration
  private let requester: HTTPRequester
  
  public init(baseURL: String, configuration: HTTPConfiguration = DefaultHTTPConfiguration(), requester: HTTPRequester = DefaultHTTPRequester()) {
    self.baseURL = baseURL
    self.configuration = configuration
    self.requester = requester
  }
  
  public var builder: URLRequestBuilder<HTTPResult<Data>> {
    return URLRequestBuilder(client: self)
  }
  
  func request(_ request: URLRequest, queue: DispatchQueue, complete: @escaping HTTPResultComplete<Data>) {
    requester(request, configuration: configuration, queue: queue, complete: complete)
  }
  
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func publisher(forRequest request: URLRequest) -> AnyPublisher<Data, HTTPError> {
    requester.publisher(forRequest: request, configuration: configuration)
  }
  #endif
}
