//
//  HTTPHeaderResponse.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2023-03-24.
//  Copyright © 2023 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

struct HTTPHeaderResponse: Decodable {
  let headers: [String: String]
}
