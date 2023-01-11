//
//  File.swift
//  
//
//  Created by Dylan Perry on 12/29/22.
//

import Foundation


import Foundation

public struct OpenAICompletionResponse: Codable {
    public let object: String
    public let model: String?
    public let choices: [OpenAICompletionChoice]
}

