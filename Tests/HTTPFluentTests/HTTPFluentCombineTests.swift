#if canImport(Combine)

import Combine
import XCTest
import HTTPFluent

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
func fulfill<E: Error>(_ e: XCTestExpectation) -> (Subscribers.Completion<E>) -> Void {
  return { c in
    if case let .failure(error) = c {
      XCTFail("\(error)")
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
    HTTPClient.bin.path("json").jsonPublisher(decoding: Slideshows.self).sink(receiveCompletion: fulfill(e), receiveValue: print(slideshows:)).store(in: &cancellables)
    wait(for: [e], timeout: 10)
  }

  func testPostJSONReactively() {
    let e = expectation(description: "http")
    let slide = Slide(title: "Posted Reactively", type: "all")
    HTTPClient.bin.path("post").post(json: slide).accept(.json).publisher.decodeToString().sink(receiveCompletion: fulfill(e)) { s in
      print(s)
    }.store(in: &cancellables)
    wait(for: [e], timeout: 10)
  }

  static var allTests = [
      ("testGetJSONReactively", testGetJSONReactively),
      ("testPostJSONReactively", testPostJSONReactively)
  ]
}

#endif
