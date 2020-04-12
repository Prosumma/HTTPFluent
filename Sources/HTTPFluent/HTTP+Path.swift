//
//  HTTP+Path.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

public extension HTTP {
  func path(percentEncoded path: String) -> Builder {
    build(\._path, path)
  }

  func path(_ segments: Any...) -> Builder {
    path(percentEncoded: segments.map { "\($0)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! }.joined(separator: "/"))
  }
}
