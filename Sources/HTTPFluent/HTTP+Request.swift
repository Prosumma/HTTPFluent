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
        case .success(let data): wrapper = .init(httpCatching: { try b._decode(data) })
        case .failure(let error): wrapper = .init(httpError: error)
        }
        complete(wrapper)
      }
      break
    case .failure(let error):
      b._queue.async {
        complete(.init(httpError: error))
      }
    }
  }
}
