//
//  HTTPBinResponse.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-04-02.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

struct HTTPBinResponse: Decodable {
  public let data: String
  public let url: String
}
