//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

import Foundation

public extension HTTP {
  func request(queue: DispatchQueue? = nil, complete: @escaping HTTPResultComplete<Data>) {
    let b = builder
    switch b.request {
    case .success(let request):
      b.requester.request(request, queue: queue, complete: complete)
    case .failure(let error):
      let queue = queue ?? b.requester.configuration.defaultQueue
      queue.async {
        complete(.failure(error))
      }
    }
  }
    
  func request<Response: Decodable>(queue: DispatchQueue? = nil, complete: @escaping HTTPResultComplete<Response>) {
    accept(.json).request(queue: queue, complete: flatMap(complete: complete, transform: decode))
  }
  
  func request(queue: DispatchQueue? = nil, complete: @escaping HTTPResultComplete<String>) {
    request(queue: queue, complete: flatMap(complete: complete, transform: stringify))
  }
  
  func request(queue: DispatchQueue? = nil, complete: @escaping HTTPComplete<Data?>) {
    request(queue: queue, complete: extract(complete))
  }
  
  func request<Response: Decodable>(queue: DispatchQueue? = nil, complete: @escaping HTTPComplete<Response?>) {
    request(queue: queue, complete: extract(complete))
  }
  
  func request(queue: DispatchQueue? = nil, complete: @escaping HTTPComplete<String?>) {
    request(queue: queue, complete: extract(complete))
  }
}

private func flatMap<Response>(complete: @escaping HTTPResultComplete<Response>, transform: @escaping (Data) -> HTTPResult<Response>) -> HTTPResultComplete<Data> {
  return { complete($0.flatMap(transform)) }
}

private func decode<Target: Decodable>(_ data: Data) -> HTTPResult<Target> {
  let decoder = JSONDecoder()
  do {
    let decoded = try decoder.decode(Target.self, from: data)
    return .success(decoded)
  } catch let e {
    debugPrint(e)
    return .failure(.decoding(e))
  }
}

private func stringify(_ data: Data) -> HTTPResult<String> {
  if let s = String(data: data, encoding: .utf8) {
    return .success(s)
  }
  return .failure(.decoding(nil))
}

private func extract<Response>(_ complete: @escaping HTTPComplete<Response?>) -> HTTPResultComplete<Response> {
  return { result in
    complete(try? result.get())
  }
}

