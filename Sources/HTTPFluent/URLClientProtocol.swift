//
//  HTTPClientProtocol.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

#if canImport(Combine)
import Combine
#endif

import Foundation

/**
 Adds the ability to publish a `URLRequest` built using
 `URLRequestBuilderProtocol`.
 */
public protocol URLClientProtocol: URLRequestBuilderProtocol {
  /**
   Publishes the `Data` result of executing the underlying `URLRequest`.
   */
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  var publisher: AnyPublisher<Data, URLError> { get }
  
  /**
   Executes the underlying `URLRequest` and calls `callback` on the given `queue` when it
   completes.
   */
  func receive(on queue: DispatchQueue, callback: @escaping (URLResult<Data>) -> Void)
}
