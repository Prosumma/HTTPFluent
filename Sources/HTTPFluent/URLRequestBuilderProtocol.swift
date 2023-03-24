//
//  URLRequestBuilder.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A conforming type may be used to build a `URLRequest`.
public protocol URLRequestBuilderProtocol {
  /**
   Returns a `Result` wrapping the `URLRequest` built
   by the fluent interface.

   If the `URLRequest` could not be built, the `Result`
   will contain an `HTTPError` specifying what went
   wrong.
   */
  var request: URLResult<URLRequest> { get }

  /// Supports the fluent interface. Do not call this directly.
  func build(_ apply: URLRequestBuilder.Apply) -> Self
}
