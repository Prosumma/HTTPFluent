//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public extension HTTP {
  func query(_ value: Any? = nil, forName name: String) -> Builder {
    var b = builder
    let value = value.flatMap{ "\($0)" }
    b._query.append(URLQueryItem(name: name, value: value))
    return b
  }
}
