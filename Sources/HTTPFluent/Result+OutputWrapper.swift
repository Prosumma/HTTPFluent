//
//  Result+OutputWrapper.swift
//  
//
//  Created by Gregory Higley on 4/5/20.
//

import Foundation

extension Result: OutputWrapper where Failure == HTTPError {
  public typealias Output = Success
  public init(httpError error: HTTPError) {
    self = .failure(error)
  }
  public init(httpOutput output: Success) {
    self = .success(output)
  }
}

