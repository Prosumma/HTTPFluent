//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

import Foundation

extension CharacterSet {
  static let urlQueryValueAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "&="))
}

extension String {
  var urlQueryValueEncoded: String {
    addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
  }
}

public struct URLRequestBuilder: HTTP {
  let requester: HTTPRequester
  var method: HTTPMethod = .get
  var escapedPath: String? = nil
  var query: [String: Any] = [:]
  var headers: [String: String] = [:]
  var body: () -> HTTPResult<Data?> = { .success(nil) }
  public init(_ requester: HTTPRequester) {
    self.requester = requester
  }
  public var builder: URLRequestBuilder {
    return self
  }
  public var request: HTTPResult<URLRequest> {
    guard var components = URLComponents(string: requester.baseURL) else {
      return .failure(.malformedUrl)
    }
    if query.count > 0 {
      let queryItems: [URLQueryItem] = query.map{ q in
        let name = q.key
        let value = "\(q.value)".urlQueryValueEncoded
        return URLQueryItem(name: name, value: value)
      }
      components.queryItems = components.queryItems ?? []
      components.queryItems?.append(contentsOf: queryItems)
    }
    if let escapedPath = escapedPath {
      components.percentEncodedPath += "/" + escapedPath
    }
    guard let url = components.url else {
      return .failure(.malformedUrl)
    }
    var request = URLRequest(url: url)
    switch body() {
    case .success(let body):
      request.httpBody = body
    case .failure(let error):
      return .failure(error)
    }
    request.httpMethod = method.rawValue
    let headers = requester.configuration.defaultHeaders.merging(self.headers, uniquingKeysWith: { $1 })
    for (field, value) in headers {
      request.setValue(value, forHTTPHeaderField: field)
    }
    return .success(request)
  }
}
