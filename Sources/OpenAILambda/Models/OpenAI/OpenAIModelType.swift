//
//  OpenAIModelType.swift
//  
//
//  Created by Dylan Perry on 12/29/22.
//

import Foundation

/// The type of model used to generate the output
public enum OpenAIModelType {
    /// ``GPT3`` Family of Models
    case gpt3(GPT3)
    
    public var modelName: String {
        switch self {
        case .gpt3(let model): return model.rawValue
        }
    }
    
    /// A set of models that can understand and generate natural language
    ///
    /// [GPT-3 Models OpenAI API Docs](https://beta.openai.com/docs/models/gpt-3)
    public enum GPT3: String {
        
        /// Most capable GPT-3 model. Can do any task the other models can do, often with higher quality, longer output and better instruction-following. Also supports inserting completions within text.
        ///
        /// > Model Name: text-davinci-003
        case davinci = "text-davinci-003"
    }
}
