//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import HTTPFluent

extension String {
  static let json = "application/json"
  static let httpBin = "https://httpbin.org"
}

extension HTTPClient {
  static let bin = HTTPClient(baseURL: .httpBin)
}
