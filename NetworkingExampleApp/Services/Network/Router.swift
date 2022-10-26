import Foundation

enum Router {
  case rings

  var scheme: String {
    return "https"
  }

  var domain: String {
    return "6356997e2712d01e14f7fb39.mockapi.io"
  }

  var path: String {
    return "/api/v1/rings"
  }

  var method: String {
    return "GET"
  }

  var headers: [String: String] {
    let header = ["Accept": "application/json"]

    return header
  }

  func urlRequest() -> URLRequest? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = domain
    components.path = path

    guard let url = components.url else {
      return nil
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method

    for (key, value) in headers {
      urlRequest.setValue(value, forHTTPHeaderField: key)
    }

    return urlRequest
  }
}
