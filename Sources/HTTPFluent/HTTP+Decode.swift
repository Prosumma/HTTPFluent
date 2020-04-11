//
//  HTTP+Decode.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

public extension HTTP where Wrapper == HTTPResult<Output> {
  var simple: URLRequestBuilder<Output?> {
    return URLRequestBuilder(copy: builder)
  }
}

public extension HTTP where Wrapper == HTTPResult<Data> {
  func decode<NewOutput>(_ decode: @escaping HTTPDecode<NewOutput>) -> URLRequestBuilder<HTTPResult<NewOutput>> {
    return URLRequestBuilder(copy: builder, decode: decode)
  }
  
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func decode<NewOutput: Decodable, Decoder: TopLevelDecoder>(_ type: NewOutput.Type = NewOutput.self, decoder: Decoder) -> URLRequestBuilder<HTTPResult<NewOutput>> where Decoder.Input == Data {
    return decode { data in try decoder.decode(type, from: data) }
  }
  #endif
  
  func decode<NewOutput: Decodable>(json type: NewOutput.Type, decoder: JSONDecoder = JSONDecoder()) -> URLRequestBuilder<HTTPResult<NewOutput>> {
    return accept(.json).decode { data in try decoder.decode(type, from: data) }
  }
  
  func decode<NewOutput>(_ type: NewOutput.Type) -> URLRequestBuilder<HTTPResult<NewOutput>> {
    decode(builder.client.configuration[type]!)
  }
  
}
