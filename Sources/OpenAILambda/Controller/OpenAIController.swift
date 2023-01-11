import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents

final class OpenAIController {
  static func route(context: LambdaContext, routeKey: String, input: OpenAILambdaInput) async -> APIGatewayV2Response {
    context.logger.info("Trying to route: \(routeKey)")
    guard let service = OpenAI.Service() else {
      context.logger.error("Invalid environment variables")
      return OpenAIResponseBuilder.handleMissingEnvVariables()
    }
    switch routeKey {
    case "POST /openAIPOC/image", "ANY /openAIPOC/image":
      let result = await service.generateImage(context: context, prompt: input.prompt)
      switch result {
      case .success(let response):
        return OpenAIResponseBuilder.handle(success: response)
      case .failure(let error):
        return OpenAIResponseBuilder.handle(failure: error)
      }
    case "POST /openAIPOC", "ANY /openAIPOC":
      let result = await service.askQuestion(context: context, prompt: input.prompt)
      switch result {
      case .success(let response):
        return OpenAIResponseBuilder.handle(success: response)
      case .failure(let error):
        return OpenAIResponseBuilder.handle(failure: error)
      }
    default:
      return OpenAIResponseBuilder.handleInvalidRoute()
    }
  }
}
