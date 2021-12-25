//
//  HTTPFluentAsyncTests.swift
//  
//
//  Created by Gregory Higley on 12/25/21.
//

#if canImport(Combine)
import Combine
#endif

import XCTest
import HTTPFluent

#if swift(>=5.5)

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
class HTTPFluentAsyncTests: XCTestCase {
  func testGetJSON() async throws {
    let slideshows = try await URLClient.bin.path("json").receive(json: Slideshows.self)
    print(slideshows)
  }
}

#endif
