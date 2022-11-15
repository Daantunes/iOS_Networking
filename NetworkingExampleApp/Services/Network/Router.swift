import Foundation

enum Router {
  case login(username: String, password: String)

  case rings
  case createRing(name: String)
  case updateRing(id: UUID, name: String)
  case deleteRing(id: UUID)
  case getRingLanguages(id: UUID)
  case updateRingLanguages(id: UUID, languages: [Language])

  case createLanguage(name:String, ringID: UUID)
  case updateLanguage(id: UUID, name: String)
  case deleteLanguage(id: UUID)

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

      case .getRingLanguages(let id), .updateRingLanguages(let id, _):
        return "/api/rings/\(id)/languages"

      case .createLanguage:
        return "/api/languages"

      case .updateLanguage(let id, _), .deleteLanguage(let id):
        return "/api/languages/\(id)"
    }
  }

  var method: String {
    switch self {
      case .rings, .getRingLanguages:
        return "GET"
      case .createRing, .createLanguage, .login:
        return "POST"
      case .updateRing, .updateLanguage, .updateRingLanguages:
        return "PUT"
      case .deleteRing, .deleteLanguage:
        return "DELETE"
    }
  }

  var body: Data? {
    switch self {
      case .createRing(let name), .updateRing(_, let name):
        var data = [String:Any]()
        data["name"] = name

        return try? JSONSerialization.data(withJSONObject: data)
      case .createLanguage(let name, let ringID):
        var data = [String:Any]()
        data["name"] = name
        data["ringID"] = "\(ringID)"

        return try? JSONSerialization.data(withJSONObject: data)
      case .updateRingLanguages(_, let languages):
        var data = [String]()
        data = languages.map { $0.name }

        return try? JSONSerialization.data(withJSONObject: data)
      default:
        return nil
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
