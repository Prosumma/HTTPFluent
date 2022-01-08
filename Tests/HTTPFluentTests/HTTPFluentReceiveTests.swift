//
//  HTTPFluentReceiveTests.swift
//  HTTPFluentTests
//
//  Created by Gregory Higley on 2020-08-12.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import XCTest
import HTTPFluent

class HTTPFluentReceiveTests: XCTestCase {

  func testGetJSON() {
    let e = expectation(description: "http")
    URLClient.bin
      .path("json")
      .receive(json: Slideshows.self) { result in
        do {
          try print(result.get())
        } catch {
          XCTFail("\(error)")
        }
        e.fulfill()
      }
    wait(for: [e], timeout: 10)
  }
  
}
