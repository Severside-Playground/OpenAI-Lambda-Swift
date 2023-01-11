import Foundation
struct EnvironmentVariableHelper {
  static func getEnvironmentVariables() -> [String: String] {
    var envVars: [String: String] = [:]
    for (key, value) in ProcessInfo.processInfo.environment {
      envVars[key] = value
    }
    return envVars
  }
}
