//
//  Const.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-04-01.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import HTTPFluent

extension String {
  static let httpBin = "https://httpbin.org"
}

extension URLClient {
  static let bin = URLClient(url: .httpBin)
}
