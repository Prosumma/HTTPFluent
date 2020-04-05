//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/4/20.
//

import Foundation

public protocol OutputWrapper {
  associatedtype Output
  init(httpError error: HTTPError)
  init(httpOutput output: Output)
  init(httpCatching catching: () throws -> Output)
}

extension Result: OutputWrapper where Failure == HTTPError {
  public typealias Output = Success
  public init(httpError error: HTTPError) {
    self = .failure(error)
  }
  public init(httpOutput output: Success) {
    self = .success(output)
  }
  public init(httpCatching catching: () throws -> Output) {
    do {
      self = .success(try catching())
    } catch let e as HTTPError {
      self = .failure(e)
    } catch {
      self = .failure(.decoding(error))
    }
  }
}

extension Optional: OutputWrapper {
  public typealias Output = Wrapped
  public init(httpError error: HTTPError) {
    self = .none
  }
  public init(httpOutput output: Wrapped) {
    self = .some(output)
  }
  public init(httpCatching catching: () throws -> Wrapped) {
    do {
      self = .some(try catching())
    } catch {
      self = .none
    }
  }
}

