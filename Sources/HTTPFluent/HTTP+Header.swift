//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

public extension HTTP {
  func header(_ value: String, forField field: HTTPHeaderField) -> URLRequestBuilder {
    let name = field.rawValue
    return build(\.headers[name], value)
  }
  
  func accept(_ value: String) -> URLRequestBuilder {
    header(value, forField: .accept)
  }
  
  func content(type value: String) -> URLRequestBuilder {
    header(value, forField: .contentType)
  }
  
  func authorization(_ value: String) -> URLRequestBuilder {
    header(value, forField: .authorization)
  }
  
  func authorization(bearer token: String) -> URLRequestBuilder {
    authorization("Bearer \(token)")
  }
}
