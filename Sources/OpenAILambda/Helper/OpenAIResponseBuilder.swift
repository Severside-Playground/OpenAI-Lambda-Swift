//
//  File.swift
//  
//
//  Created by Dylan Perry on 1/10/23.
//

import Foundation
import Foundation
import AWSLambdaEvents

struct OpenAIResponseBuilder {
  static func handle<T: Codable>(success response: T) -> APIGatewayV2Response {
    guard
      let jsonData = try? JSONEncoder().encode(response),
      let bodyAsString = String(data: jsonData, encoding: String.Encoding.utf8)
    else {
      return APIGatewayV2Response(
        statusCode: .internalServerError,
        headers: ["content-type": "application/json"],
        body: "Invalid response structure from provider"
      )
    }
    
    let apigwResponse = APIGatewayV2Response(
      statusCode: .ok,
      headers: ["content-type": "application/json"],
      body: bodyAsString
    )
    return apigwResponse
  }
  
  static func handle(failure error: OpenAIError) -> APIGatewayV2Response {
    switch error {
    case .genericError(let message):
      return APIGatewayV2Response(
        statusCode: .internalServerError,
        headers: ["content-type": "application/json"],
        body: message
      )
    case .decodingError(let message):
      return APIGatewayV2Response(
        statusCode: .internalServerError,
        headers: ["content-type": "application/json"],
        body: message
      )
    }
  }
  
  static func handleInvalidRoute() -> APIGatewayV2Response {
    APIGatewayV2Response(
      statusCode: .badRequest,
      headers: ["content-type": "application/json"],
      body: "Invalid route"
    )
  }
  
  static func handleInvalidInput() -> APIGatewayV2Response {
    APIGatewayV2Response(
      statusCode: .badRequest,
      headers: ["content-type": "application/json"],
      body: "Invalid body provided"
    )
  }
  
  static func handleMissingEnvVariables() -> APIGatewayV2Response {
    APIGatewayV2Response(
      statusCode: .internalServerError,
      headers: ["content-type": "application/json"],
      body: "Invalid server configuration"
    )
  }
}
