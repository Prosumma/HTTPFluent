//
//  HTTPClient.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct URLClient: Sendable {
  public typealias ResponseHandler = @Sendable (Data?, URLResponse?) throws -> Data
  
  let session: URLSession
  var builder: URLRequestBuilder
  let responseHandler: ResponseHandler

  public init(
    builder: URLRequestBuilder,
    session: URLSession = URLSession(configuration: .ephemeral),
    responseHandler: @escaping ResponseHandler = URLClient.defaultResponseHandler
  ) {
    self.session = session
    self.builder = builder
    self.responseHandler = responseHandler
  }

  public init(
    url: URL,
    session: URLSession = URLSession(configuration: .ephemeral),
    responseHandler: @escaping ResponseHandler = URLClient.defaultResponseHandler
  ) {
    self.init(builder: URLRequestBuilder(url: url), session: session, responseHandler: responseHandler)
  }

  public init(
    url: String,
    session: URLSession = URLSession(configuration: .ephemeral),
    responseHandler: @escaping ResponseHandler = URLClient.defaultResponseHandler
  ) {
    self.init(builder: URLRequestBuilder(url: url), session: session, responseHandler: responseHandler)
  }
  
  public static func defaultResponseHandler(data: Data?, response: URLResponse?) throws -> Data {
    guard let data = data, let response = response else {
      throw URLError.unknown
    }
    if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
      throw URLError.http(response: response, data: data)
    }
    return data
  }
}

extension URLClient: URLClientProtocol {
  public var request: URLResult<URLRequest> {
    builder.request
  }

  public var receivePublisher: AnyPublisher<Data, URLError> {
    request.publisher.flatMap { req in
      self.session
        .dataTaskPublisher(for: req)
        .tryMap { try self.responseHandler($0, $1) }
        .mapToURLError
    }.eraseToAnyPublisher()
  }
  
  public func receive(on queue: DispatchQueue = DispatchQueue.global(), callback: @escaping @Sendable (URLResult<Data>) -> Void) {
    switch request {
    case .failure(let error):
      queue.async { callback(.failure(error)) }
    case .success(let request):
      let task = session.dataTask(with: request) { (data, response, error) in
        var result: URLResult<Data> = .failure(.unknown)
        defer {
          let result = result
          queue.async { callback(result) }
        }
        if let error = error {
          return result = .failure(.error(error))
        }
        do {
          result = try .success(self.responseHandler(data, response))
        } catch let error as URLError {
          return result = .failure(error)
        } catch {
          return result = .failure(.error(error))
        }
      }
      task.resume()
    }
  }
  
  public func receive() async throws -> Data {
    switch request {
    case .failure(let error):
      throw error
    case .success(let request):
      let (data, response): (Data?, URLResponse?)
      do {
        #if os(Linux)
          (data, response) = try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: request) { (data, response, error) in
              if let error = error { continuation.resume(throwing: error) }
              continuation.resume(returning: (data, response))
            }
            task.resume()
          }
        #else
          (data, response) = try await session.data(for: request)
        #endif
      } catch {
        throw URLError.error(error)
      }
      return try responseHandler(data, response)
    }
  }

  public func build(_ apply: (inout URLRequestBuilder) -> Void) -> URLClient {
    var client = self
    apply(&client.builder)
    return client
  }
}
