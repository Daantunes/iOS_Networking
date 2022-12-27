import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

enum HTTPTask {
  case request
  case requestParameters(parameters: [String: Any])
  case requestData(data: Encodable)
}

protocol EndPoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: [String: String]? { get }

  func urlRequest() -> URLRequest?
}

extension EndPoint {
  func urlRequest() -> URLRequest? {
    var urlRequest = URLRequest(url: baseURL.appendingPathExtension(path))
    urlRequest.httpMethod = method.rawValue

    switch task {
      case .requestData(let data):
        if let body = try? JSONSerialization.data(withJSONObject: data) {
          urlRequest.httpBody = body
        }
      case .requestParameters(let data):
        if let body = try? JSONSerialization.data(withJSONObject: data) {
          urlRequest.httpBody = body
        }
      default:
        break
    }

    if let headers {
      for (key, value) in headers {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }

    return urlRequest
  }
}
