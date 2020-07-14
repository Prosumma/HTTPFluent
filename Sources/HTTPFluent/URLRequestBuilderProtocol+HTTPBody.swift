//
//  URLRequestBuilderProtocol+POST.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-05-09.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Combine
import Foundation

public extension URLRequestBuilderProtocol {
  /// Send `Data` without setting an HTTP method.
  func send(data: Data) -> Self {
    body { data }
  }

  /// Send `FormData` without setting an HTTP method.
  func send(form: FormData) -> Self {
    content(type: form.contentType).body { form.encoded() }
  }

  /// Encode a type in the HTTP body without setting an HTTP method.
  func send<Request: Encodable, Encoder: TopLevelEncoder>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    body { try encoder.encode(request) }
  }

  /// Send JSON in the HTTP body without setting an HTTP method.
  func send<Request: Encodable>(json request: Request) -> Self {
    send(request, encoder: JSONEncoder()).content(type: .json)
  }

  /// Post `Data`
  func post(data: Data) -> Self {
    send(data: data).method(.post)
  }

  /// Post `FormData`
  func post(form: FormData) -> Self {
    send(form: form).method(.post)
  }

  /// Post `Request` encoded with `Encoder`
  func post<Request: Encodable, Encoder: TopLevelEncoder>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    send(request, encoder: encoder).method(.post)
  }

  /// Post `Request` encoded as JSON
  func post<Request: Encodable>(json request: Request) -> Self {
    send(json: request).method(.post)
  }

  /// Patch `Data`
  func patch(data: Data) -> Self {
    send(data: data).method(.patch)
  }

  /// Patch `FormData`
  func patch(form: FormData) -> Self {
    send(form: form).method(.patch)
  }

  /// Patch `Request` encoded with `Encoder`
  func patch<Request: Encodable, Encoder: TopLevelEncoder>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    send(request, encoder: encoder).method(.patch)
  }

  /// Patch `Request` encoded as JSON
  func patch<Request: Encodable>(json request: Request) -> Self {
    send(json: request).method(.patch)
  }

  /// Put `Data`
  func put(data: Data) -> Self {
    send(data: data).method(.put)
  }

  /// Put `FormData`
  func put(form: FormData) -> Self {
    send(form: form).method(.put)
  }

  /// Put `Request` encoded by `Encoder`
  func put<Request: Encodable, Encoder: TopLevelEncoder>(
    _ request: Request,
    encoder: Encoder
  ) -> Self where Encoder.Output == Data {
    send(request, encoder: encoder).method(.put)
  }

  /// Put `Request` encoded as JSON
  func put<Request: Encodable>(json request: Request) -> Self {
    send(json: request).method(.put)
  }
}