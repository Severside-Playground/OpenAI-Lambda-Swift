//
//  File.swift
//  
//
//  Created by Dylan Perry on 12/29/22.
//

import Foundation

extension OpenAI {
  enum Endpoint {
    case completions
    case edits
    case imageGeneration
  }
}

extension OpenAI.Endpoint {
  var path: String {
      switch self {
      case .completions:
          return "/v1/completions"
      case .edits:
          return "/v1/edits"
      case .imageGeneration:
          return "/v1/images/generations"
      }
  }
  
  var method: String {
      switch self {
      case .completions, .edits, .imageGeneration:
          return "POST"
      }
  }
  
  func baseURL() -> String {
      switch self {
      case .completions, .edits, .imageGeneration:
          return "https://api.openai.com"
      }
  }
}
