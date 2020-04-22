//
//  String.Encoding+IANA.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 4/12/20.
//

import Foundation

extension String.Encoding {
  /**
   Gets the standard IANA character set name for the receiver.
   
   See [https://stackoverflow.com/q/61177410/27779](https://stackoverflow.com/q/61177410/27779).
   */
  var ianaName: String {
    let enc = CFStringConvertNSStringEncodingToEncoding(rawValue)
    return CFStringConvertEncodingToIANACharSetName(enc)! as String
  }
}
