//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Combine
import Foundation

public struct URLRequestBuilder<Wrapper: OutputWrapper>: HTTP {
  public typealias Output = Wrapper.Output
  
  public let client: HTTPClient
  
  let _decode: HTTPDecode<Output>
  var _encode: HTTPEncode?
  var _method: HTTPMethod = .get
  var _query: [URLQueryItem] = []
  var _path: String?
  var _queue: DispatchQueue
  var _headers: [String: String] = [:]
  
  public init(client: HTTPClient, decode: @escaping HTTPDecode<Output>) {
    self._queue = client.configuration.defaultQueue
    self.client = client
    self._decode = decode
  }
  
  public init<PreviousWrapper: OutputWrapper>(copy: URLRequestBuilder<PreviousWrapper>, decode: @escaping HTTPDecode<Output>) {
    self.init(client: copy.client, decode: decode)
    _encode = copy._encode
    _method = copy._method
    _query = copy._query
    _path = copy._path
    _queue = copy._queue  
    _headers = copy._headers
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
      components.queryItems = _query;
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
}

public extension HTTP {
  func build<Value>(_ keyPath: WritableKeyPath<Builder, Value>, _ value: Value) -> Builder {
    var b = builder
    b[keyPath: keyPath] = value
    return b
  }
  
  func method(_ method: HTTPMethod) -> Builder {
    build(\._method, method)
  }
  
  func body(encode: @escaping HTTPEncode) -> Builder {
    build(\._encode, encode)
  }
  
  func queue(_ queue: DispatchQueue) -> Builder {
    build(\._queue, queue)
  }
}

