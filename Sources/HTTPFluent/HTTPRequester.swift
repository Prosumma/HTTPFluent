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

public protocol HTTPRequester {
  var baseURL: String { get }
  var configuration: HTTPRequesterConfiguration { get }
  func request(_ request: URLRequest, queue: DispatchQueue?, complete: @escaping HTTPResultComplete<Data>)
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func publisher(forRequest request: URLRequest) -> AnyPublisher<Data, HTTPError>
  #endif
}

public extension HTTPRequester {
  func request(_ request: URLRequest, queue: DispatchQueue? = nil, complete: @escaping HTTPResultComplete<Data>) {
    self.request(request, queue: queue, complete: complete)
  }
}
