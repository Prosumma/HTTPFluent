//
//  HTTPFluentReceiveTests.swift
//  HTTPFluentTests
//
//  Created by Gregory Higley on 8/12/20.
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
