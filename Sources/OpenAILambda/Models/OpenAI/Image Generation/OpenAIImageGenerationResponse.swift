//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/1/23.
//

import Foundation

struct OpenAIImageGenerationResponse: Codable {
  let created: Float
  let data: [OpenAIImageGenerationData]
}
