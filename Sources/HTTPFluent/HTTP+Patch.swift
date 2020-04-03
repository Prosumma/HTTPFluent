//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import Foundation

public extension HTTP {
  func patch<Body: Encodable>(json: Body, encoder: JSONEncoder) -> URLRequestBuilder {
    body(json: json, encoder: encoder).method(.patch)
  }
  
  func patch<Body: Encodable>(json: Body) -> URLRequestBuilder {
    body(json: json).method(.patch)
  }
  
  func patch(data: Data) -> URLRequestBuilder {
    body(data: data).method(.patch)
  }
  
  func patch(string: String, encoding: String.Encoding = .utf8) -> URLRequestBuilder {
    body(string: string, encoding: encoding).method(.patch)
  }
  
  func patch(form: FormData) -> URLRequestBuilder {
    body(form: form).method(.patch)
  }
}
