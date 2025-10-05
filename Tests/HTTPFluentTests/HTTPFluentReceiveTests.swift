//
//  HTTPFluentReceiveTests.swift
//  HTTPFluentTests
//
//  Created by Gregory Higley on 2020-08-12.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import HTTPFluent
import Testing

struct HTTPFluentReceiveTests {
  @Test func testGetJSON() async throws {
    _ = try await withCheckedThrowingContinuation { cont in
      URLClient.bin
        .path("json")
        .receive(json: Slideshows.self) { result in
          cont.resume(with: result)
        }
    }
  }
}