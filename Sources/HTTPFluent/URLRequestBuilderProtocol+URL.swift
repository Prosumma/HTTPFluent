//
//  URLRequestBuilderProtocol+URL.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

public extension URLRequestBuilderProtocol {
  /// Set the port
  func port(_ port: UInt) -> Self {
    build(URLRequestBuilder.buildPort(port))
  }

  /**
   Sets the path as a sequence of unescaped path segments. The path
   is _appended_ to any existing path from the base URL.

   ```swift
   let builder = URLRequestBuilder(url: "https://foo.com/api")
   let x = "bar"
   builder.path(["foo/bar", x])
   ```

   Notice that the base URL already contains the path `api`, so our
   resulting path is `api/foo/bar`.

   - parameter segments: The unescaped path segments
   */
  func path<Segments: Sequence>(_ segments: Segments) -> Self where Segments.Element == Any {
    build(URLRequestBuilder.buildPath(segments.map { "\($0)" }))
  }

  /**
   Sets the path as unescaped path segments. The path
   is _appended_ to any existing path from the base URL.

   ```swift
   let builder = URLRequestBuilder(url: "https://foo.com/api")
   let x = "bar"
   builder.path("foo/bar", x)
   ```

   Notice that the base URL already contains the path `api`, so our
   resulting path is `api/foo/bar`.

   - parameter segments: The unescaped path segments
   */
  func path(_ segments: Any...) -> Self {
    path(segments)
  }

  /// Adds a query item
  func query(_ value: Any?, forName name: String) -> Self {
    build(URLRequestBuilder.buildQuery(value, forName: name))
  }
}
