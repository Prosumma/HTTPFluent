//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import Foundation

public extension HTTP {
  
  func body(encode: @escaping () -> HTTPResult<Data?>) -> URLRequestBuilder {
    build(\.body, encode)
  }
  
  func body<Body>(encoding value: Body, using encode: @escaping (Body) throws -> Data) -> URLRequestBuilder {
    body {
      do {
        return try .success(encode(value))
      } catch {
        return .failure(.encoding(error))
      }
    }
  }
  
  func body<Body: Encodable, Encoder: DataEncoder>(encoding value: Body, encoder: Encoder) -> URLRequestBuilder {
    body(encoding: value, using: encoder.encode)
  }
  
  func body<Body: Encodable>(json: Body, encoder: JSONEncoder) -> URLRequestBuilder {
    body(encoding: json, encoder: encoder).content(type: .json)
  }
  
  func body<Body: Encodable>(json: Body) -> URLRequestBuilder {
    body(encoding: json, encoder: JSONEncoder()).content(type: .json)
  }
  
  func body(data: Data) -> URLRequestBuilder {
    build(\.body, { .success(data) })
  }
  
  func body(string: String, encoding: String.Encoding = .utf8) -> URLRequestBuilder {
    func encode(_ string: String) throws -> Data {
      guard let data = string.data(using: encoding) else {
        throw HTTPError.encoding(nil)
      }
      return data
    }
    return body(encoding: string, using: encode)
  }
  
  func body(form: FormData) -> URLRequestBuilder {
    body(data: form.encode()).content(type: form.mimeType)
  }
  
}
