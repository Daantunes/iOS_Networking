import Foundation

enum Router {
  case rings
  case createRing(name: String)
  case updateRing(id: UUID, name: String)
  case deleteRing(id: UUID)
  case login(username: String, password: String)

  var scheme: String {
    return "http"
  }

  var domain: String {
    return "localhost"
  }

  var port: Int {
    return 8080
  }

  var path: String {
    switch self {
      case .rings, .createRing:
        return "/api/rings"

      case .updateRing(let id, _), .deleteRing(let id):
        return "/api/rings/\(id)"

      case .login:
        return "/api/users/login"
    }
  }

  var method: String {
    switch self {
      case .rings:
        return "GET"
      case .createRing, .login:
        return "POST"
      case .updateRing:
        return "PUT"
      case .deleteRing:
        return "DELETE"
    }
  }

  var body: Data? {
    switch self {
      case .rings, .deleteRing, .login:
        return nil
      case .createRing(let name), .updateRing(_, let name):
        var data = [String:Any]()
        data["name"] = name

        return try? JSONSerialization.data(withJSONObject: data)
    }
  }

  var headers: [String: String] {
    var header = ["Content-Type": "application/json"]

    switch self {
      case .login(let username, let password):
        guard let loginString = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
          fatalError("Failed to encode credentials")
        }

        header["Authorization"] = "Basic \(loginString)"
      default:
        if let token = Session.shared.accessToken {
          header["Authorization"] = "Bearer \(token)"
        }
    }

    return header
  }

  func urlRequest() -> URLRequest? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = domain
    components.port = port
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
