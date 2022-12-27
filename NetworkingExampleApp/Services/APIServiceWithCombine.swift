import Combine
import Foundation

struct APIServiceWithCombine {
  static let shared = APIServiceWithCombine()
  private let requestManager = RequestManagerWithCombine()

  func loginUser(username: String, password: String) -> AnyPublisher<Token,RequestErrorType> {
    requestManager.sendRequest(router: .login(username: username, password: password))
      .decode(type: Token.self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func getAllRings() -> AnyPublisher<[Ring],RequestErrorType> {
    requestManager.sendRequest(router: .rings)
      .decode(type: [Ring].self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func createRing(name: String) -> AnyPublisher<Ring, RequestErrorType> {
    requestManager.sendRequest(router: .createRing(name: name))
      .decode(type: Ring.self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

    func createRingWithLanguages(name: String, languages: [Language]) -> AnyPublisher<Void, RequestErrorType> {
      requestManager.sendRequest(router: .createRing(name: name))
        .decode(type: Ring.self, decoder: JSONDecoder())
        .flatMap { ring in
          requestManager.sendRequest(router: .updateRingLanguages(id: ring.id, languages: languages))
            .tryMap { data in
              if data.isEmpty { return Void() }
              throw RequestErrorType.decodeFailed
            }
        }
        .mapError { handleError(error: $0) }
        .eraseToAnyPublisher()
    }

  func updateRing(id: UUID, name: String) -> AnyPublisher<Ring, RequestErrorType>  {
    requestManager.sendRequest(router: .updateRing(id: id, name: name))
      .decode(type: Ring.self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func deleteRing(id: UUID) -> AnyPublisher<Void, RequestErrorType> {
    requestManager.sendRequest(router: .deleteRing(id: id))
      .tryMap { data in
        if data.isEmpty { return Void() }
        throw RequestErrorType.decodeFailed
      }
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func getRingLanguages(ringID: UUID)  -> AnyPublisher<[Language], RequestErrorType> {
    requestManager.sendRequest(router: .getRingLanguages(id: ringID))
      .decode(type: [Language].self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func updateRingLanguages(ringID: UUID, languages: [Language]) -> AnyPublisher<Void, RequestErrorType> {
    requestManager.sendRequest(router: .updateRingLanguages(id: ringID, languages: languages))
      .tryMap { data in
        if data.isEmpty { return Void() }
        throw RequestErrorType.decodeFailed
      }
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func getAllLanguages() -> AnyPublisher<[Language], RequestErrorType> {
    requestManager.sendRequest(router: .languages)
      .decode(type: [Language].self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func createLanguage(name: String, ringID: UUID) -> AnyPublisher<Language, RequestErrorType> {
    requestManager.sendRequest(router: .createLanguage(name: name, ringID: ringID))
      .decode(type: Language.self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func updateLanguage(id: UUID, name: String, ringID: UUID) -> AnyPublisher<Language, RequestErrorType> {
    requestManager.sendRequest(router: .updateLanguage(id: id, name: name, ringID: ringID))
      .decode(type: Language.self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func deleteLanguage(id: UUID) -> AnyPublisher<Void, RequestErrorType> {
    requestManager.sendRequest(router: .deleteLanguage(id: id))
      .tryMap { data in
        if data.isEmpty { return Void() }
        throw RequestErrorType.decodeFailed
      }
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func searchLanguages(query: String) -> AnyPublisher<[Language], RequestErrorType> {
    requestManager.sendRequest(router: .searchLanguages(query: query))
      .decode(type: [Language].self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  func getLanguageRing(id: UUID) -> AnyPublisher<Ring, RequestErrorType> {
    requestManager.sendRequest(router: .getLanguageRing(id: id))
      .decode(type: Ring.self, decoder: JSONDecoder())
      .mapError { handleError(error: $0) }
      .eraseToAnyPublisher()
  }

  private func handleError(error: Error) -> RequestErrorType {
    if let _ = error as? Swift.DecodingError {
      return RequestErrorType.decodeFailed
    }
    if let errorType = error as? RequestErrorType {
      return errorType
    }
    return RequestErrorType.unknown
  }
}
