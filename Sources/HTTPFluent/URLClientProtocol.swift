//
//  HTTPClientProtocol.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

#if canImport(Combine)
import Combine
#endif

/**
 Adds the ability to publish a `URLRequest` built using
 `URLRequestBuilderProtocol`.
 */
public protocol URLClientProtocol: URLRequestBuilderProtocol {
#if canImport(Combine)
  /**
   Publishes the `Data` result of executing the underlying `URLRequest`.
   */
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  var receivePublisher: AnyPublisher<Data, URLError> { get }
#endif
  
#if swift(>=5.5)
  @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
  func receive() async throws -> Data
#endif

  /**
   Executes the underlying `URLRequest` and calls `callback` on the given `queue` when it
   completes.
   */
  func receive(on queue: DispatchQueue, callback: @escaping (URLResult<Data>) -> Void)
}
