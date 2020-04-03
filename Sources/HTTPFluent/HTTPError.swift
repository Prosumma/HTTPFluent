//
//  File.swift
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
  case http(status: Int, response: Data)
  
  public static var unknown: HTTPError {
    .error(nil)
  }
}
