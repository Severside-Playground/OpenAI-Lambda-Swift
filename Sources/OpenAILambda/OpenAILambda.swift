import AWSLambdaRuntimeCore
import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

@main
public struct OpenAILambda: SimpleLambdaHandler {
  public init() {}
  public func handle(_ request: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response {
    let routeKey = request.routeKey
    guard
      let requestBody = request.body,
      let input = try? JSONDecoder().decode(OpenAILambdaInput.self,  from: Data(requestBody.utf8))
    else {
      context.logger.error("Invalid body provided - could not convert JSON into expected object")
      return OpenAIResponseBuilder.handleInvalidInput()
    }
  
    return await OpenAIController.route(context: context, routeKey: routeKey, input: input)
  }

}
