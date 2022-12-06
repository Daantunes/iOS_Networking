import Foundation

struct APIService {
  static let shared = APIService()
  private let requestManager = RequestManager()

  func loginUser(username: String, password: String, completion: @escaping (Result<Token, RequestError>) -> Void) {
    requestManager.sendRequest(
      router: .login(username: username, password: password),
      responseModel: Token.self,
      completion: completion
    )
  }

  func getAllRings(completion: @escaping (Result<[Ring], RequestError>) -> Void) {
    requestManager.sendRequest(router: .rings, responseModel: [Ring].self, completion: completion)
  }

  func createRing(name: String, completion: @escaping (Result<Ring, RequestError>) -> Void) {
    requestManager.sendRequest(router: .createRing(name: name), responseModel: Ring.self, completion: completion)
  }

  func updateRing(id: UUID, name: String, completion: @escaping (Result<Ring, RequestError>) -> Void) {
    requestManager.sendRequest(
      router: .updateRing(id: id, name: name),
      responseModel: Ring.self,
      completion: completion
    )
  }

  func deleteRing(id: UUID, completion: @escaping (Result<Void, RequestError>) -> Void) {
    requestManager.sendRequest(router: .deleteRing(id: id), completion: completion)
  }

  func getRingLanguages(ringID: UUID, completion: @escaping (Result<[Language], RequestError>) -> Void) {
    requestManager.sendRequest(
      router: .getRingLanguages(id: ringID),
      responseModel: [Language].self,
      completion: completion
    )
  }

  func updateRingLanguages(
    ringID: UUID,
    languages: [Language],
    completion: @escaping (Result<Void, RequestError>) -> Void
  ) {
    requestManager.sendRequest(router: .updateRingLanguages(id: ringID, languages: languages), completion: completion)
  }

  func getAllLanguages(completion: @escaping (Result<[Language], RequestError>) -> Void) {
    requestManager.sendRequest(router: .languages, responseModel: [Language].self, completion: completion)
  }

  func createLanguage(name: String, ringID: UUID, completion: @escaping (Result<Language, RequestError>) -> Void) {
    requestManager.sendRequest(
      router: .createLanguage(name: name, ringID: ringID),
      responseModel: Language.self,
      completion: completion
    )
  }

  func updateLanguage(id: UUID, name: String, ringID: UUID, completion: @escaping (Result<Language, RequestError>) -> Void) {
    requestManager.sendRequest(
      router: .updateLanguage(id: id, name: name, ringID: ringID),
      responseModel: Language.self,
      completion: completion
    )
  }

  func deleteLanguage(id: UUID, completion: @escaping (Result<Void, RequestError>) -> Void) {
    requestManager.sendRequest(router: .deleteLanguage(id: id), completion: completion)
  }

  func searchLanguages(query: String, completion: @escaping (Result<[Language], RequestError>) -> Void) {
    requestManager.sendRequest(
      router: .searchLanguages(query: query),
      responseModel: [Language].self,
      completion: completion
    )
  }

  func getLanguageRing(id: UUID, completion: @escaping (Result<Ring, RequestError>) -> Void) {
    requestManager.sendRequest(router: .getLanguageRing(id: id), responseModel: Ring.self, completion: completion)
  }
}
