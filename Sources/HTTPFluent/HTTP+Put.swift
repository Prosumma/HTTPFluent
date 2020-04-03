//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import Foundation

public extension HTTP {
  func put<Body: Encodable>(json: Body, encoder: JSONEncoder) -> URLRequestBuilder {
    body(json: json, encoder: encoder).method(.put)
  }
  
  func put<Body: Encodable>(json: Body) -> URLRequestBuilder {
    body(json: json).method(.put)
  }
  
  func put(data: Data) -> URLRequestBuilder {
    body(data: data).method(.put)
  }
  
  func put(string: String, encoding: String.Encoding = .utf8) -> URLRequestBuilder {
    body(string: string, encoding: encoding).method(.put)
  }
  
  func put(form: FormData) -> URLRequestBuilder {
    body(form: form).method(.put)
  }
}
