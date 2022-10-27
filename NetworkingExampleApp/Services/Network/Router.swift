import Foundation

enum Router {
  case rings
  case createRing(name: String)

  var scheme: String {
    return "https"
  }

  var domain: String {
    return "6356997e2712d01e14f7fb39.mockapi.io"
  }

  var path: String {
    switch self {
      case .rings, .createRing:
        return "/api/v1/rings"
    }
  }

  var method: String {
    switch self {
      case .rings:
        return "GET"
      case .createRing:
        return "POST"
    }
  }

  var body: Data? {
    switch self {
      case .rings:
        return nil
      case .createRing(let name):
        var data = [String:Any]()
        data["name"] = name

        return try? JSONSerialization.data(withJSONObject: data)
    }
  }

  var headers: [String: String] {
    let header = ["Content-Type": "application/json"]

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
    urlRequest.httpBody = body

    for (key, value) in headers {
      urlRequest.setValue(value, forHTTPHeaderField: key)
    }

    return urlRequest
  }
}
