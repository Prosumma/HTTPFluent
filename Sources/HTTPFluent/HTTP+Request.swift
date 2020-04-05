//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public extension HTTP {
  func request(complete: @escaping HTTPComplete<Wrapper>) {
    let b = builder
    switch b.request {
    case .success(let request):
      b.client.request(request, queue: b._queue) { result in
        let wrapper: Wrapper
        switch result {
        case .success(let data):
          do {
            wrapper = .init(httpOutput: try b._decode(data))
          } catch let e as HTTPError {
            wrapper = .init(httpError: e)
          } catch {
            wrapper = .init(httpError: .decoding(error))
          }
        case .failure(let error):
          wrapper = .init(httpError: error)
        }
        complete(wrapper)
      }
      break
    case .failure(let error):
      b.client.configuration.defaultQueue.async {
        complete(.init(httpError: error))
      }
    }
  }
}
