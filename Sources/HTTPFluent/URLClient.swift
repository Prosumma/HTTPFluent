//
//  HTTPClient.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

#if canImport(Combine)
import Combine
#endif

import Foundation

/**
 Perform HTTP operations on a base URL.

 Most uses of HTTP at Patron and other organizations
 perform one or more operations against some API hosted
 at a specific base URL. `HTTPClient` makes this very
 easy and natural using a fluent interface.

 This is best illustrated with an example:

 ```swift
 let jwt: String = "...imagine a JWT..."
 let token = "xyz123"
 let attendee = Attendee(token: token)
 let client = HTTPClient(url: "https://api.patron.com/api")
 await client
   .path("attendee", token) // api/attendee/xyz123
   .query(7, forName: "x") // ?x=7
   .authorization(bearer: jwt)
   .post(json: attendee)
   .receive(json: AttendeeResponse.self)
 ```
 */
public struct URLClient {
  public typealias ResponseHandler = (Data?, URLResponse?) throws -> Data
  
  let session: URLSession
  var builder: URLRequestBuilder
  let responseHandler: ResponseHandler

  public init(builder: URLRequestBuilder, session: URLSession = URLSession(configuration: .ephemeral), responseHandler: @escaping ResponseHandler = URLClient.defaultResponseHandler) {
    self.session = session
    self.builder = builder
    self.responseHandler = responseHandler
  }

  public init(url: URL, session: URLSession = URLSession(configuration: .ephemeral), responseHandler: @escaping ResponseHandler = URLClient.defaultResponseHandler) {
    self.init(builder: URLRequestBuilder(url: url), session: session, responseHandler: responseHandler)
  }

  public init(url: String, session: URLSession = URLSession(configuration: .ephemeral), responseHandler: @escaping ResponseHandler = URLClient.defaultResponseHandler) {
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

  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public var receivePublisher: AnyPublisher<Data, URLError> {
    request.publisher.flatMap { req in
      self.session
        .dataTaskPublisher(for: req)
        .tryMap { try self.responseHandler($0, $1) }
        .mapToURLError
    }.eraseToAnyPublisher()
  }
  
  public func receive(on queue: DispatchQueue = DispatchQueue.global(), callback: @escaping (URLResult<Data>) -> Void) {
    switch request {
    case .failure(let error):
      queue.async { callback(.failure(error)) }
    case .success(let request):
      let task = session.dataTask(with: request) { (data, response, error) in
        var result: URLResult<Data> = .failure(.unknown)
        defer { queue.async { callback(result) } }
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
  
  #if swift(>=5.5)

  @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
  public func receive() async throws -> Data {
    switch request {
    case .failure(let error):
      throw error
    case .success(let request):
      let (data, response): (Data, URLResponse)
      do {
        (data, response) = try await session.data(for: request)
      } catch {
        throw URLError.error(error)
      }
      return try responseHandler(data, response)
    }
  }

  #endif

    
  public func build(_ apply: (inout URLRequestBuilder) -> Void) -> URLClient {
    var client = self
    apply(&client.builder)
    return client
  }
}
