//
//  HTTPError.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

import Foundation

public enum HTTPError: Error {
  case error(Error?)
  case malformedUrl
  case encoding(Error?)
  case decoding(Error?)
  case http(response: HTTPURLResponse, data: Data)
  
  public static let unknown = HTTPError.error(nil)
}

