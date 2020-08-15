//
//  Const.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 4/1/20.
//

import HTTPFluent

extension String {
  static let httpBin = "https://httpbin.org"
}

extension URLClient {
  static let bin = URLClient(url: .httpBin)
}
