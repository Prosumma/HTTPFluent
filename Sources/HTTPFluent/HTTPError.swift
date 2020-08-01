//
//  HTTPError.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-02-24.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

/// An error that may occurs as a result of constructing or publishing a `URLRequest` over HTTP.
public enum HTTPError: Error {
  case error(Error?)
  case malformedURL(String?)
  case encoding(Error?)
  case decoding(Error?)
  case http(response: HTTPURLResponse, data: Data)

  public static let unknown = HTTPError.error(nil)
}
