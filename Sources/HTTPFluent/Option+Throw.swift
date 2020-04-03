//
//  File.swift
//  
//
//  Created by Gregory Higley on 4/2/20.
//

extension Optional {
  func flatMapThrow(_ error: Error) throws -> Wrapped {
    if let value = self {
      return value
    }
    throw error
  }
}

infix operator ??! : LogicalDisjunctionPrecedence

func ??! <T>(lhs: T?, rhs: Error) throws -> T {
  try lhs.flatMapThrow(rhs)
}
