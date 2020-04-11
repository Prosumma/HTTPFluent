//
//  HTTP+Header.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

private extension String {
    static let accept = "Accept"
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
}

public extension HTTP {
  func header(_ value: String, forName name: String) -> Builder {
    build(\._headers[name], value)
  }
  
  func accept(_ accept: String) -> Builder {
    header(accept, forName: .accept)
  }
  
  func content(type contentType: String) -> Builder {
    header(contentType, forName: .contentType)
  }
  
  func authorization(_ authorization: String) -> Builder {
    header(authorization, forName: .authorization)
  }
  
  func authorization(bearer token: String) -> Builder {
    authorization("Bearer \(token)")
  }
}
