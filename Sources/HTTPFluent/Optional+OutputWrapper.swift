//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/5/20.
//

import Foundation

extension Optional: OutputWrapper {
  public typealias Output = Wrapped
  public init(httpError error: HTTPError) {
    self = .none
  }
  public init(httpOutput output: Wrapped) {
    self = .some(output)
  }
}

