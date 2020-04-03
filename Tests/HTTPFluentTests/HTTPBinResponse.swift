//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/2/20.
//

import Foundation

struct HTTPBinResponse: Decodable {
  public let data: String
  public let url: String
}
