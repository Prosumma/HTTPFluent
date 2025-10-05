//
//  HTTPFluentAsyncTests.swift
//  
//
//  Created by Gregory Higley on 2021-12-25.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import HTTPFluent
import Testing

struct HTTPFluentAsyncTests {
  @Test func testGetJSON() async throws {
    let slideshows = try await URLClient.bin.path("json").receive(json: Slideshows.self)
    #expect(slideshows.slideshow.title == "Sample Slide Show")
  }
  
  @Test func testHeaders() async throws {
    let response = try await URLClient.bin.path("headers").content(type: .json, charset: .utf8).receive(json: HTTPHeaderResponse.self)
    #expect(response.headers["Content-Type"] == "application/json;charset=utf-8")
  }
}
