//
//  URLRequestBuilder.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct URLRequestBuilder: Sendable {
  public typealias Apply = (inout Self) -> Void

  fileprivate var error: URLError?
  fileprivate var components: URLComponents
  fileprivate var method: String = "GET"
  fileprivate var headers: [String: String] = [:]
  fileprivate var body: (@Sendable () throws -> Data)?

  private init(components: URLComponents) {
    self.components = components
  }

  public init(url: String) {
    if let tempComponents = URLComponents(string: url) {
      self.init(components: tempComponents)
    } else {
      self.init(components: URLComponents())
      error = .malformedURL(url)
    }
  }

  public init(url: URL) {
    self.init(url: url.absoluteString)
  }
}

extension URLRequestBuilder: URLRequestBuilderProtocol {
  public var request: URLResult<URLRequest> {
    if let error = error {
      return .failure(error)
    }
    // The url has been checked already. It's safe to force-unwrap.
    let url = components.url! //swiftlint:disable:this force_unwrapping
    var request = URLRequest(url: url)
    request.url = components.url
    request.httpMethod = method
    do {
      request.httpBody = try body?()
    } catch {
      return .failure(.encoding(error))
    }
    for (field, value) in headers {
      request.setValue(value, forHTTPHeaderField: field)
    }
    return .success(request)
  }

  public func build(_ apply: URLRequestBuilder.Apply) -> URLRequestBuilder {
    var builder = self
    apply(&builder)
    return builder
  }
}

extension URLRequestBuilder {
  static func buildPort(_ port: UInt) -> Apply {
    return { builder in
      builder.components.port = Int(port)
    }
  }

  static func buildPath<Segments: Sequence>(
    _ segments: Segments
  ) -> URLRequestBuilder.Apply where Segments.Element == String {
    return { builder in
      builder.components.path += "/" + segments.joined(separator: "/")
    }
  }

  static func buildQuery(_ value: Any?, forName name: String) -> Apply {
    return { builder in
      var queryItems = builder.components.queryItems ?? []
      let string: String?
      if let value = value {
        string = "\(value)"
      } else {
        string = nil
      }
      queryItems.append(URLQueryItem(name: name, value: string))
      builder.components.queryItems = queryItems
    }
  }

  static func buildMethod(_ method: String) -> URLRequestBuilder.Apply {
    return { builder in
      builder.method = method
    }
  }

  static func buildHeader(_ value: String, forField field: String) -> URLRequestBuilder.Apply {
    return { builder in
      builder.headers[field] = value
    }
  }

  static func buildBody(_ body: @escaping @Sendable () throws -> Data) -> URLRequestBuilder.Apply {
    return { builder in
      builder.body = body
    }
  }
}
