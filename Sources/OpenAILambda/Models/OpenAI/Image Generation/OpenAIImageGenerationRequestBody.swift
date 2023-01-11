//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/1/23.
//

import Foundation

struct OpenAIImageGenerationRequestBody: Codable {
  let prompt: String
  var n: Int = 1
  var size: String = "1024x1024"
}
