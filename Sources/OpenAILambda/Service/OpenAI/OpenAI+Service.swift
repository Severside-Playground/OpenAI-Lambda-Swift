//
//  File.swift
//  
//
//  Created by Dylan Perry on 12/29/22.
//

import Foundation
import AsyncHTTPClient
import AWSLambdaRuntime
import AWSLambdaEvents
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

extension OpenAI {
  struct Service {
    private let openAITokenName: String = "openAIToken"
    private let openAIToken: String
    public init?() {
      let envVars = EnvironmentVariableHelper.getEnvironmentVariables()
      guard let openAIToken = envVars[openAITokenName] else {
        return nil
      }
      self.openAIToken = openAIToken
    }
    
    public func askQuestion(context: LambdaContext, prompt: String) async -> Result<OpenAILambdaResponse, OpenAIError> {
      // Begin process
      context.logger.info("Beginning Request to OpenAI Completion Endpoint.")
      // Initial Setup
      let endpoint = Endpoint.completions
      let model: OpenAIModelType = .gpt3(.davinci)
      let maxTokens = 100
      let body = OpenAICompletionRequestBody(prompt: prompt, model: model.modelName, maxTokens: maxTokens)
      // Build and make request
      guard
        let request = prepareRequest(context: context, endpoint: endpoint, body: body),
        let response: OpenAICompletionResponse = await makeRequest(context: context, request: request),
        let responseMessage = response.choices.first?.text
      else {
        context.logger.error("Request to OpenAI Completion endpoint failed or was never made.")
        return .failure(OpenAIError.genericError(errorMessage: "Server-Side failure"))
      }
      return .success(OpenAILambdaResponse(message: responseMessage))
    }
    
    public func generateImage(context: LambdaContext, prompt: String) async -> Result<OpenAILambdaImageResponse, OpenAIError> {
      // Begin process
      context.logger.info("Beginning Request to OpenAI Image Generation Endpoint.")
      // Initial setup
      let endpoint = Endpoint.imageGeneration
      let body = OpenAIImageGenerationRequestBody(prompt: prompt)
      // Build and make request
      guard
        let request = prepareRequest(context: context, endpoint: endpoint, body: body),
        let response: OpenAIImageGenerationResponse = await makeRequest(context: context, request: request),
        let imageURL = response.data.first?.url
      else {
        context.logger.error("Request to OpenAI Image Generation endpoint failed or was never made.")
        return .failure(OpenAIError.genericError(errorMessage: "Server-Side failure"))
      }
      
      return .success(OpenAILambdaImageResponse(url: imageURL))
    }
  }
}

extension OpenAI.Service {
  private func prepareRequest<T: Codable>(context: LambdaContext, endpoint: OpenAI.Endpoint, body: T) -> HTTPClientRequest? {
    
    let urlString = endpoint.baseURL() + endpoint.path
    var request = HTTPClientRequest(url: urlString)
    request.method = .POST
    request.headers.add(name: "Authorization", value: "Bearer \(self.openAIToken)")
    request.headers.add(name: "Content-Type", value: "application/json")
    
    guard let encodedJSON = try? JSONEncoder().encode(body)
    else {
      context.logger.error("Could not encode body object")
      return nil
    }
    
    request.body = .bytes(encodedJSON)
    return request
  }
  
  private func makeRequest<T: Codable>(context: LambdaContext, request: HTTPClientRequest) async -> T? {
    let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
    do {
      let response = try await httpClient.execute(request, timeout: .seconds(30))
      try? await httpClient.shutdown()
      context.logger.info("Request MADE to : \(request.url)")
      guard var body = try? await response.body.collect(upTo: 1024 * 1024) else {
        context.logger.info("Nothing in body")
        return nil
      }
      guard
        let responseBody = body.readString(length: body.writerIndex, encoding: .utf8),
        let responseData = responseBody.data(using: .utf8)
      else {
        context.logger.info("couldn't read from body as a string")
        return nil
      }
      context.logger.info("Response Body is to : \(responseBody)")
      let result = try JSONDecoder().decode(T.self, from: responseData)
      context.logger.info("Created the response object!")
      return result
    } catch {
      try? await httpClient.shutdown()
      context.logger.error("Something went wrong -- \(error.localizedDescription)")
      return nil
    }
    
   }
}
