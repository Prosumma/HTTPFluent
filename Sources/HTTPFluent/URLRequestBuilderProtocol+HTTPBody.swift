//
//  URLRequestBuilderProtocol+POST.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-09.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension URLRequestBuilderProtocol {
  /**
   Low-level function to set the HTTP body.

   Don't use this. Use higher-level functions like `post(json:)`,
   which ultimately call this one.
   */
  func body(_ body: @escaping @Sendable () throws -> Data) -> Self {
    build(URLRequestBuilder.buildBody(body))
  }
  
  /// Send `Data` without setting an HTTP method.
  func send(data: Data) -> Self {
    body { data }
  }

  /// Send a `String` without setting an HTTP method.
  func send(string: String, encoding: String.Encoding = .utf8) -> Self {
    send(data: string.data(using: .utf8)!)
  }

  /// Send `FormData` without setting an HTTP method.
  func send(form: FormData) -> Self {
    content(type: form.contentType).body { form.encoded() }
  }

  /// Encode a type in the HTTP body without setting an HTTP method.
  func send<Request: Encodable & Sendable, Encoder: TopLevelEncoder & Sendable>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    body { try encoder.encode(request) }
  }

  /// Send JSON in the HTTP body without setting an HTTP method.
  func send<Request: Encodable & Sendable>(json request: Request) -> Self {
    send(request, encoder: JSONEncoder()).content(type: .json)
  }

  /// Post `Data`
  func post(data: Data) -> Self {
    send(data: data).method(.post)
  }

  /// Post a `String`
  func post(string: String, encoding: String.Encoding = .utf8) -> Self {
    send(string: string, encoding: encoding).method(.post)
  }

  /// Post `FormData`
  func post(form: FormData) -> Self {
    send(form: form).method(.post)
  }

  /// Post `Request` encoded with `Encoder`
  func post<Request: Encodable & Sendable, Encoder: TopLevelEncoder & Sendable>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    send(request, encoder: encoder).method(.post)
  }

  /// Post `Request` encoded as JSON
  func post<Request: Encodable & Sendable>(json request: Request) -> Self {
    send(json: request).method(.post)
  }

  /// Patch `Data`
  func patch(data: Data) -> Self {
    send(data: data).method(.patch)
  }

  /// Patch a `String`
  func patch(string: String, encoding: String.Encoding = .utf8) -> Self {
    send(string: string, encoding: encoding).method(.patch)
  }

  /// Patch `FormData`
  func patch(form: FormData) -> Self {
    send(form: form).method(.patch)
  }

  /// Patch `Request` encoded with `Encoder`
  func patch<Request: Encodable & Sendable, Encoder: TopLevelEncoder & Sendable>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    send(request, encoder: encoder).method(.patch)
  }

  /// Patch `Request` encoded as JSON
  func patch<Request: Encodable & Sendable>(json request: Request) -> Self {
    send(json: request).method(.patch)
  }

  /// Put `Data`
  func put(data: Data) -> Self {
    send(data: data).method(.put)
  }

  /// Put a `String`
  func put(string: String, encoding: String.Encoding = .utf8) -> Self {
    send(string: string, encoding: encoding).method(.put)
  }

  /// Put `FormData`
  func put(form: FormData) -> Self {
    send(form: form).method(.put)
  }

  /// Put `Request` encoded by `Encoder`
  func put<Request: Encodable & Sendable, Encoder: TopLevelEncoder & Sendable>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    send(request, encoder: encoder).method(.put)
  }

  /// Put `Request` encoded as JSON
  func put<Request: Encodable & Sendable>(json request: Request) -> Self {
    send(json: request).method(.put)
  }
}
