//
//  URLRequestBuilder.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Combine
import Foundation

public struct URLRequestBuilder<Wrapper: OutputWrapper>: HTTP {
  public typealias Output = Wrapper.Output

  let client: HTTPClient
  let _decode: HTTPDecode<Output>

  var _encode: HTTPEncode?
  var _headers: [String: String] = [:]
  var _method: HTTPMethod = .get
  var _path: String?
  var _query: [URLQueryItem] = []
  var _queue: DispatchQueue

  public init(client: HTTPClient, decode: @escaping HTTPDecode<Output>) {
    self._queue = client.configuration.defaultQueue
    self.client = client
    self._decode = decode
  }

  public init<PreviousWrapper: OutputWrapper>(copy: URLRequestBuilder<PreviousWrapper>, decode: @escaping HTTPDecode<Output>) {
    self.init(client: copy.client, decode: decode)
    _encode = copy._encode
    _headers = copy._headers
    _method = copy._method
    _path = copy._path
    _query = copy._query
    _queue = copy._queue
  }

  public init<PreviousWrapper: OutputWrapper>(copy: URLRequestBuilder<PreviousWrapper>) where PreviousWrapper.Output == Output {
    self.init(copy: copy, decode: copy._decode)
  }

  public var builder: URLRequestBuilder<Wrapper> {
    return self
  }

  public var request: HTTPResult<URLRequest> {
    guard var components = URLComponents(string: client.baseURL) else {
      return .failure(.malformedUrl)
    }
    if let path = _path {
      components.percentEncodedPath += "/" + path
    }
    if _query.count > 0 {
      components.queryItems = _query
    }
    guard let url = components.url, !url.isFileURL else {
      return .failure(.malformedUrl)
    }
    var request = URLRequest(url: url)
    request.httpMethod = _method.rawValue
    if let encode = _encode {
      do {
        request.httpBody = try encode()
      } catch let e as HTTPError {
        return .failure(e)
      } catch {
        return .failure(.encoding(error))
      }
    }
    let headers: [String: String] = client.configuration.defaultHeaders.merging(_headers, uniquingKeysWith: { $1 })
    for (name, value) in headers {
      request.setValue(value, forHTTPHeaderField: name)
    }
    return .success(request)
  }
}

public extension URLRequestBuilder where Output == Data {
  init(client: HTTPClient) {
    self.init(client: client, decode: { data in data })
  }
  init(baseURL: String) {
    self.init(client: HTTPClient(baseURL: baseURL))
  }
}
