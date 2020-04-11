//
//  HTTPComplete.swift
//  
//
//  Created by Gregory Higley on 4/1/20.
//

public typealias HTTPComplete<Response> = (Response) -> Void
public typealias HTTPResultComplete<Success> = HTTPComplete<HTTPResult<Success>>
