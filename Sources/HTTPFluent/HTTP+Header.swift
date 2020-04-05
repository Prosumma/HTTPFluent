//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

public extension HTTP {
  func header(_ value: String, forName name: String) -> Builder {
    build(\._headers[name], value)
  }
  
  func accept(_ accept: String) -> Builder {
    header(accept, forName: "Accept")
  }
  
  func content(type contentType: String) -> Builder {
    header(contentType, forName: "Content-Type")
  }
  
  func authorization(_ authorization: String) -> Builder {
    header(authorization, forName: "Authorization")
  }
  
  func authorization(bearer token: String) -> Builder {
    authorization("Bearer \(token)")
  }
}
