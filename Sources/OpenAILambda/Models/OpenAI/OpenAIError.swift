//
//  OpenAIError.swift
//  
//
//  Created by Dylan Perry on 12/29/22.
//

import Foundation

public enum OpenAIError: Error {
  case genericError(errorMessage: String)
  case decodingError(errorMessage: String)
}
