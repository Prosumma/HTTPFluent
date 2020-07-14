//
//  HTTPClient.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-08.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Combine
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
 client
   .path("attendee", token) // api/attendee/xyz123
   .query(7, forName: "x") // ?x=7
   .authorization(bearer: jwt)
   .post(json: attendee)
   .dataTaskPublisher(decoding: AttendeeResponse.self)
 ```

 Under the hood, `HTTPClient` uses `HTTPClient` to perform
 its requests.
 */
public struct HTTPClient {
  let session: URLSession
  var builder: URLRequestBuilder

  public init(builder: URLRequestBuilder, session: URLSession = URLSession(configuration: .ephemeral)) {
    self.session = session
    self.builder = builder
  }

  public init(url: URL, session: URLSession = URLSession(configuration: .ephemeral)) {
    self.init(builder: URLRequestBuilder(url: url), session: session)
  }

  public init(url: String, session: URLSession = URLSession(configuration: .ephemeral)) {
    self.init(builder: URLRequestBuilder(url: url), session: session)
  }
}

extension HTTPClient: HTTPClientProtocol {
  public var request: Result<URLRequest, HTTPError> {
    builder.request
  }

  public var publisher: AnyPublisher<Data, HTTPError> {
    builder.request.publisher.flatMap { req in
      return self.session.dataTaskPublisher(for: req).tryMap { (data, response) in
        guard let response = response as? HTTPURLResponse else {
          throw HTTPError.unknown
        }
        if !(200..<300).contains(response.statusCode) {
          throw HTTPError.http(response: response, data: data)
        }
        return data
      }.mapToHttpError
    }.eraseToAnyPublisher()
  }

  public func build(_ apply: (inout URLRequestBuilder) -> Void) -> HTTPClient {
    var client = self
    apply(&client.builder)
    return client
  }
}
