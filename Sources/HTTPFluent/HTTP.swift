//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public protocol HTTP {
  associatedtype Output = Data
  associatedtype Wrapper: OutputWrapper where Wrapper.Output == Output
  typealias Builder = URLRequestBuilder<Wrapper>
  var builder: Builder { get }
}
