//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public extension HTTP {
  func query(_ value: String? = nil, forName name: String) -> Builder {
    var b = builder
    b._query.append(URLQueryItem(name: name, value: value))
    return b
  }
}
