//
//  HTTPFluentCombineTests.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-04-01.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import XCTest
import HTTPFluent

func fulfill<E: Error>(_ e: XCTestExpectation, expectError: Bool = false) -> (Subscribers.Completion<E>) -> Void {
  return { c in
    if expectError {
      if case .finished = c {
        //swiftlint:disable:next xctfail_message
        XCTFail()
      }
    } else {
      if case let .failure(error) = c {
        XCTFail("\(error)")
      }
    }
    e.fulfill()
  }
}

final class HttpFluentCombineTests: XCTestCase {

  func testGetJSON() {
    let e = expectation(description: "http")
    func print(slideshows: Slideshows) {
      Swift.print(slideshows)
    }
    let cancellable = URLClient.bin
      .path("json")
      .receivePublisher(json: Slideshows.self)
      .sink(
        receiveCompletion: fulfill(e),
        receiveValue: print(slideshows:)
      )
    wait(for: [e], timeout: 10)
    cancellable.cancel()
  }

  func testPostJSON() {
    let e = expectation(description: "http")
    let slide = Slide(title: "Posted Reactively", type: "all")
    let cancellable = URLClient.bin
      .path("post")
      .post(json: slide)
      .accept(.json)
      .receivePublisher(decode: Decoders.string)
      .sink(receiveCompletion: fulfill(e)) { s in
        print(s)
      }
    wait(for: [e], timeout: 10)
    cancellable.cancel()
  }

  func testHTTPStatusCode() {
    let e = expectation(description: "http")
    let statusCode = 500
    let cancellable = URLClient.bin
      .path("status", statusCode)
      .accept(.json)
      .method(.put)
      .receivePublisher(decode: Decoders.string)
      .sink(
        receiveCompletion: fulfill(e, expectError: true),
        receiveValue: { _ in XCTFail("Expected HTTP Status \(statusCode).") }
      )
    wait(for: [e], timeout: 10)
    cancellable.cancel()
  }
}
