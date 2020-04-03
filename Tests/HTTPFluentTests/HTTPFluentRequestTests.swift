import XCTest
import HTTPFluent

final class HttpFluentRequestTests: XCTestCase {

  func testGetJSON() {
    let e = expectation(description: "http")
    HTTPClient.bin.path("json").accept(.json).request { (result: HTTPResult<Slideshows>) in
      switch result {
      case .success(let slideshows):
        print(slideshows)
      case .failure(let error):
        XCTFail("\(error)")
      }
      e.fulfill()
    }
    wait(for: [e], timeout: 10)
  }

  func testPostJSON() {
    let e = expectation(description: "http")
    let slide = Slide(title: "You", type: "all")
    HTTPClient.bin.path("post").post(json: slide).request { (result: String?) in
      if let result = result {
        print(result)
      } else {
        XCTFail()
      }
      e.fulfill()
    }
    wait(for: [e], timeout: 10)
  }

  func testHttpStatusCode() {
    let e = expectation(description: "http")
    HTTPClient.bin.path("status", 500).accept(.json).method(.put).request { (result: HTTPResult<String>) in
      switch result {
      case let .failure(.http(status: status, response: _)):
        print(status)
      default:
        XCTFail()
      }
      e.fulfill()
    }
    wait(for: [e], timeout: 10)
  }

  static var allTests = [
      ("testGetJSON", testGetJSON),
      ("testPostJSON", testPostJSON),
      ("testHttpStatusCode", testHttpStatusCode)
  ]
}
