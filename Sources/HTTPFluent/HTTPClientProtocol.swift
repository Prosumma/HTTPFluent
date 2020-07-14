//
//  HTTPClientProtocol.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Combine
import Foundation

/**
 Adds the ability to invoke a `URLRequest` built using
 `URLRequestBuilderProtocol`.
 */
public protocol HTTPClientProtocol: URLRequestBuilderProtocol {
  /**
   Returns a publisher that wraps a URL session data task for a given URL request.

   The publisher publishes Data when the task completes, or terminates if the task fails with an error.

   - returns: A publisher that wraps data for the URL request.
   */
  var publisher: AnyPublisher<Data, HTTPError> { get }
}
