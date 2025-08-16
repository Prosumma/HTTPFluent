//
//  HTTPClientProtocol.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import Foundation

/**
 Adds the ability to publish a `URLRequest` built using
 `URLRequestBuilderProtocol`.
 */
public protocol URLClientProtocol: URLRequestBuilderProtocol {
  /**
   Publishes the `Data` result of executing the underlying `URLRequest`.
   */
  var receivePublisher: AnyPublisher<Data, URLError> { get }

  /**
   Gets the result of the `URLRequest` asynchronously as `Data`.
   */
  func receive() async throws -> Data

  /**
   Executes the underlying `URLRequest` and calls `callback` on the given `queue` when it
   completes.
   */
  func receive(on queue: DispatchQueue, callback: @escaping @Sendable (URLResult<Data>) -> Void)
}
