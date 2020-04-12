//
//  HTTPRequest.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public extension HTTP {
  /**
   Perform an HTTP request.
   
   The request is actually performed by the underlying `HTTPClient`,
   which in turn delegates to its `HTTPRequester`. By default,
   the `complete` callback occurs on a random background queue.
   This can be changed using the `queue` combinator.
   
   - parameter complete: The callback that occurs when
   the request completes.
   */
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
    case .failure(let error):
      b._queue.async {
        complete(.init(httpError: error))
      }
    }
  }
}
