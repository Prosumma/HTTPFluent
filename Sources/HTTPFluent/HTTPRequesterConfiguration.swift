//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/31/20.
//

import Foundation

public protocol HTTPRequesterConfiguration {
  var permittedStatusCodes: [Int] { get }
  var defaultQueue: DispatchQueue { get }
  var defaultHeaders: [String: String] { get }
}

