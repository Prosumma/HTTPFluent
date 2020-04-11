import XCTest
import HTTPFluent

final class HttpFluentRequestTests: XCTestCase {

  func testGetJSON() {
    let e = expectation(description: "http")
    HTTPClient.bin
      .path("json")
      .decode(json: Slideshows.self)
      .request { result in
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
    HTTPClient.bin
      .path("post")
      .post(json: slide)
      .decode(String.self)
      .simple
      .request { result in
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
    HTTPClient.bin
      .path("status", 500)
      .accept(.json)
      .method(.put)
      .decode(String.self)
      .request { result in
        switch result {
        case let .failure(.http(response: response, data: _)):
          print(response.statusCode)
        default:
          XCTFail()
        }
        e.fulfill()
      }
    wait(for: [e], timeout: 10)
  }
  
}
