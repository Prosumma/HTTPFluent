//
//  HTTPError.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-02-24.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

public enum HTTPError: Error {
  case error(Error?)
  case malformedURL(String?)
  case encoding(Error?)
  case decoding(Error?)
  case http(response: HTTPURLResponse, data: Data?)

  public static let unknown = HTTPError.error(nil)

  public static func http(response: HTTPURLResponse) -> HTTPError {
    .http(response: response, data: nil)
  }
}

extension HTTPError: LocalizedError {
  public var errorDescription: String? {
    let message: String
    switch self {
    case .error(.none):
      message = "Unknown error"
    case .error(.some(let error)):
      message = error.localizedDescription
    case .malformedURL(.none):
      message = "Malformed URL"
    case .malformedURL(.some(let url)):
      message = "Malformed URL: \(url)"
    case .encoding(.none):
      message = "An unknown encoding error occurred."
    case .encoding(.some(let error)):
      message = "An encoding error occurred: \(error.localizedDescription)"
    case .decoding(.none):
      message = "An unknown decoding error occurred."
    case .decoding(.some(let error)):
      message = "A decoding error occurred: \(error.localizedDescription)"
    case let .http(response: response, data: _):
      message = "Status code: \(response.statusCode)"
    }
    return "[HTTPError] \(message)"
  }
}
