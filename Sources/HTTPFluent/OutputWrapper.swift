//
//  OutputWrapper.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public protocol OutputWrapper {
  associatedtype Output
  init(httpError error: HTTPError)
  init(httpOutput output: Output)
}
