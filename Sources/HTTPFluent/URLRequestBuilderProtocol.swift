//
//  URLRequestBuilder.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

public protocol URLRequestBuilderProtocol {
  /**
   Returns a `Result` wrapping the `URLRequest` built
   by the fluent interface.

   If the `URLRequest` could not be built, the `Result`
   will contain an `HTTPError` specifying what went
   wrong.
   */
  var request: Result<URLRequest, HTTPError> { get }

  /// Supports the fluent interface. Do not call this directly.
  func build(_ apply: URLRequestBuilder.Apply) -> Self
}
