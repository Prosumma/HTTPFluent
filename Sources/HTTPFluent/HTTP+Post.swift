//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import Foundation

public extension HTTP {
  func post<Body: Encodable>(json: Body, encoder: JSONEncoder) -> URLRequestBuilder {
    body(json: json, encoder: encoder).method(.post)
  }
  
  func post<Body: Encodable>(json: Body) -> URLRequestBuilder {
    body(json: json).method(.post)
  }
  
  func post(data: Data) -> URLRequestBuilder {
    body(data: data).method(.post)
  }
  
  func post(string: String, encoding: String.Encoding = .utf8) -> URLRequestBuilder {
    body(string: string, encoding: encoding).method(.post)
  }
  
  func post(form: FormData) -> URLRequestBuilder {
    body(form: form).method(.post)
  }
}
