#if canImport(Combine)

import Combine
import XCTest
import HTTPFluent

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class HttpFluentCombineTests: XCTestCase {
  var cancellables: Set<AnyCancellable> = []

  func testGetJSONReactively() {
    let e = expectation(description: "http")
    func print(slideshows: Slideshows) {
      Swift.print(slideshows)
    }
    URLClient.bin
      .path("json")
      .publisher(decoding: Slideshows.self)
      .sink(
        receiveCompletion: fulfill(e),
        receiveValue: print(slideshows:)
      )
      .store(in: &cancellables)
    wait(for: [e], timeout: 10)
  }

  func testPostJSONReactively() {
    let e = expectation(description: "http")
    let slide = Slide(title: "Posted Reactively", type: "all")
    URLClient.bin
      .path("post")
      .post(json: slide)
      .accept(.json)
      .stringPublisher()
      .sink(receiveCompletion: fulfill(e)) { s in
        print(s)
      }
      .store(in: &cancellables)
    wait(for: [e], timeout: 10)
  }

  func testHTTPStatusCodeReactively() {
    let e = expectation(description: "http")
    let statusCode = 500
    URLClient.bin
      .path("status", statusCode)
      .accept(.json)
      .method(.put)
      .stringPublisher()
      .sink(
        receiveCompletion: fulfill(e, expectError: true),
        receiveValue: { _ in XCTFail("Expected HTTP Status \(statusCode).") }
      )
      .store(in: &cancellables)
    wait(for: [e], timeout: 10)
  }
}

#endif
