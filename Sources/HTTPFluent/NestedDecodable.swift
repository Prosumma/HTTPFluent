//
//  NestedDecodable.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 5/13/20.
//  Copyright © 2020 Prosumma. All rights reserved.
//

import Foundation

//swiftlint:disable force_unwrapping

/**
 `NestedDecodable` allows a developer to skip arbitrary nested containers
 to get at some value in JSON data.

 Consider the following JSON:

 ```javascript
 {
   "data": {
     "id": "3xyz",
     "response": {
       "customer": {
         "id": 476,
         "name": "Dave Gahan"
       }
     }
   }
 }
 ```

 Such nesting is common in APIs. In many cases, we are only interested in some nested part of
 the JSON, not the entire thing. If we want to get at just "customer" without having to create
 any intermediate `Decodable` types, we can use `NestedDecodable`.

 ```swift
 enum ContainerKeys: String, CodingKey {
   case "data"
   case "response"
 }

 // Order is important. We want "data" first then "response".
 let nestedKeys: [ContainerKeys] = [.data, .response]
 let decoder = JSONDecoder()
 decoder.userInfo[.nestedCodingKeys] = nestedKeys
 let container = try decoder.decode(NestedDecodable<Customer, ContainerKeys>.self, from: data)
 let customer = container.content
 ```
 */
public struct NestedDecodable<Content: Decodable, NestedCodingKeys: CodingKey>: Decodable {
  let content: Content

  init<Keys: Collection>(
    in container: KeyedDecodingContainer<NestedCodingKeys>,
    keys: Keys
  ) throws where Keys.Element == NestedCodingKeys {
    switch keys.count {
    case 0:
      preconditionFailure("At least one nested coding key is required to use NestedDecodable.")
    case 1:
      content = try container.decode(Content.self, forKey: keys.first!)
    default:
      let container = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: keys.first!)
      self = try .init(in: container, keys: keys.dropFirst())
    }
  }

  public init(from decoder: Decoder) throws {
    guard let keys = decoder.userInfo[.nestedCodingKeys] as? [NestedCodingKeys] else {
      preconditionFailure("Nested coding keys are required to use NestedDecodable.")
    }
    let container = try decoder.container(keyedBy: NestedCodingKeys.self)
    try self.init(in: container, keys: keys)
  }
}

public extension CodingUserInfoKey {
  static let nestedCodingKeys = CodingUserInfoKey(rawValue: "com.patrontechnology.nestedCodingKeys")!
}
