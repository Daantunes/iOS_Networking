import Foundation

enum NewRouter {
  case login(username: String, password: String)

  case rings
  case createRing(name: String)
  case updateRing(id: UUID, name: String)
  case deleteRing(id: UUID)
  case getRingLanguages(id: UUID)
  case updateRingLanguages(id: UUID, languages: [Language])

  case languages
  case searchLanguages(query: String)
  case createLanguage(name: String, ringID: UUID)
  case updateLanguage(id: UUID, name: String, ringID: UUID)
  case deleteLanguage(id: UUID)
  case getLanguageRing(id: UUID)
}

extension NewRouter: EndPoint {
  var baseURL: URL {
    URL(string: "http://localhost:8080")!
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

      case .languages, .createLanguage:
        return "/api/languages"

      case .updateLanguage(let id, _, _), .deleteLanguage(let id):
        return "/api/languages/\(id)"

      case .searchLanguages:
        return "/api/languages/search"

      case .getLanguageRing(let id):
        return "/api/languages/\(id)/ring"
    }
  }

  var method: HTTPMethod {
    switch self {
      case .rings, .languages, .getRingLanguages, .getLanguageRing, .searchLanguages:
        return .get
      case .createRing, .createLanguage, .login:
        return .post
      case .updateRing, .updateLanguage, .updateRingLanguages:
        return .put
      case .deleteRing, .deleteLanguage:
        return .delete
    }
  }

  var task: HTTPTask {
    switch self {
      case .searchLanguages(let query):
        return .requestParameters(parameters: ["term": query])
      case .createRing(let name), .updateRing(_, let name):
        var data = [String:Any]()
        data["name"] = name

        return .requestParameters(parameters: data)
      case .createLanguage(let name, let ringID):
        var data = [String:Any]()
        data["name"] = name
        data["ringID"] = "\(ringID)"

        return .requestParameters(parameters: data)
      case .updateLanguage(_, let name, let ringID):
        var data = [String:Any]()
        data["name"] = name
        data["ringID"] = "\(ringID)"

        return .requestParameters(parameters: data)
      case .updateRingLanguages(_, let languages):
        var data = [String]()
        data = languages.map { $0.name }

        return .requestData(data: data)
      default:
        return .request
    }
  }

  var headers: [String: String]? {
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
}
