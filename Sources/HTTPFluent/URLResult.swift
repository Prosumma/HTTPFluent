//
//  URLResult.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-08-02.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

import Foundation

public typealias URLResult<Success: Sendable> = Result<Success, URLError>
