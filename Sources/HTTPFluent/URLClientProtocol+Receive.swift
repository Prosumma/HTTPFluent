//
//  URLClientProtocol+Receive.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-08-12.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Combine
import Foundation

//swiftlint:disable function_default_parameter_at_end
public extension URLClientProtocol {
  
  /**
   Executes the underlying `URLRequest` and calls `callback` on the given `queue` when it
   completes.
   
   The `queue` defaults to a random global `DispatchQueue`.
   */
  func receive(
    on queue: DispatchQueue = DispatchQueue.global(),
    callback: @escaping @Sendable (URLResult<Data>) -> Void)
  {
    receive(on: queue, callback: callback)
  }
  
  /**
   Executes the underlying `URLRequest` and calls `callback` on the given `queue` when it
   completes, passing `Data` through the `decode` function to give the `Response`.
   
   The `queue` defaults to a random global `DispatchQueue`.
   */
  func receive<Response>(
    on queue: DispatchQueue = DispatchQueue.global(),
    decode: @escaping Decoders.Decode<Response>,
    callback: @escaping @Sendable (URLResult<Response>) -> Void
  ) {
    receive(on: queue) { result in
      do {
        try callback(.success(decode(result.get())))
      } catch let error as URLError {
        callback(.failure(error))
      } catch {
        callback(.failure(.decoding(error)))
      }
    }
  }
    
  func receive<Response, Decoder: Sendable>(
    decoding type: Response.Type = Response.self,
    decoder: Decoder,
    on queue: DispatchQueue = DispatchQueue.global(),
    callback: @escaping @Sendable (URLResult<Response>) -> Void
  ) where Response: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
    let fluent = decoder is JSONDecoder ? accept(.json) : self
    return fluent.receive(on: queue, decode: Decoders.decode(type, with: decoder), callback: callback)
  }

  func receive<Response>(
    json type: Response.Type = Response.self,
    on queue: DispatchQueue = DispatchQueue.global(),
    callback: @escaping @Sendable (URLResult<Response>) -> Void
  ) where Response: Decodable {
    receive(on: queue, decode: Decoders.json(type), callback: callback)
  }
}

