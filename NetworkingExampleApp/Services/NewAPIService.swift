import Foundation

struct NewAPIService {
  static let shared = NewAPIService()
  private let requestManager = NewRequestManager()

  func loginUser(username: String, password: String, completion: @escaping (Result<Token, RequestError>) -> Void) {
    requestManager.sendRequest(router: .login(username: username, password: password)) { response in
      completion(handleRequestResponse(responseModel: Token.self, response: response))
    }
  }

  func getAllRings(completion: @escaping (Result<[Ring], RequestError>) -> Void) {
    requestManager.sendRequest(router: .rings) { response in
      completion(handleRequestResponse(responseModel: [Ring].self, response: response))
    }
  }

  func createRing(name: String, completion: @escaping (Result<Ring, RequestError>) -> Void) {
    requestManager.sendRequest(router: .createRing(name: name)) { response in
      completion(handleRequestResponse(responseModel: Ring.self, response: response))
    }
  }

  func createRingWithLanguages(name: String, languages: [Language], completion: @escaping (Result<Void, RequestError>) -> Void) {
    requestManager.sendRequest(router: .createRing(name: name)) { result in
      switch result {
        case .success(let data):
          if let ring = decodeData(responseModel: Ring.self, data) {
            requestManager.sendRequest(router: .updateRingLanguages(id: ring.id, languages: languages)) { response in
              completion(handleRequestResponse(response: response))
            }
          } else {
            completion(.failure(.decodeFailed))
          }
        case .failure(let error):
          completion(.failure(error))
      }
    }
  }

  func updateRing(id: UUID, name: String, completion: @escaping (Result<Ring, RequestError>) -> Void) {
    requestManager.sendRequest(router: .updateRing(id: id, name: name)) { response in
      completion(handleRequestResponse(responseModel: Ring.self, response: response))
    }
  }

  func deleteRing(id: UUID, completion: @escaping (Result<Void, RequestError>) -> Void) {
    requestManager.sendRequest(router: .deleteRing(id: id)) { response in
      completion(handleRequestResponse(response: response))
    }
  }

  func getRingLanguages(ringID: UUID, completion: @escaping (Result<[Language], RequestError>) -> Void) {
    requestManager.sendRequest(router: .getRingLanguages(id: ringID)) { response in
      completion(handleRequestResponse(responseModel: [Language].self, response: response))
    }
  }

  func updateRingLanguages(
    ringID: UUID,
    languages: [Language],
    completion: @escaping (Result<Void, RequestError>) -> Void
  ) {
    requestManager.sendRequest(router: .updateRingLanguages(id: ringID, languages: languages)) { response in
      completion(handleRequestResponse(response: response))
    }
  }

  func getAllLanguages(completion: @escaping (Result<[Language], RequestError>) -> Void) {
    requestManager.sendRequest(router: .languages) { response in
      completion(handleRequestResponse(responseModel: [Language].self, response: response))
    }
  }

  func createLanguage(name: String, ringID: UUID, completion: @escaping (Result<Language, RequestError>) -> Void) {
    requestManager.sendRequest(router: .createLanguage(name: name, ringID: ringID)) { response in
      completion(handleRequestResponse(responseModel: Language.self, response: response))
    }
  }

  func updateLanguage(
    id: UUID,
    name: String,
    ringID: UUID,
    completion: @escaping (Result<Language, RequestError>) -> Void
  ) {
    requestManager.sendRequest(router: .updateLanguage(id: id, name: name, ringID: ringID)) { response in
      completion(handleRequestResponse(responseModel: Language.self, response: response))
    }
  }

  func deleteLanguage(id: UUID, completion: @escaping (Result<Void, RequestError>) -> Void) {
    requestManager.sendRequest(router: .deleteLanguage(id: id)) { response in
      completion(handleRequestResponse(response: response))
    }
  }

  func searchLanguages(query: String, completion: @escaping (Result<[Language], RequestError>) -> Void) {
    requestManager.sendRequest(router: .searchLanguages(query: query)) { response in
      completion(handleRequestResponse(responseModel: [Language].self, response: response))
    }
  }

  func getLanguageRing(id: UUID, completion: @escaping (Result<Ring, RequestError>) -> Void) {
    requestManager.sendRequest(router: .getLanguageRing(id: id)) { response in
      completion(handleRequestResponse(responseModel: Ring.self, response: response))
    }
  }

  private func handleRequestResponse<T:Decodable>(
    responseModel: T.Type,
    response: Result<Data,RequestError>
  ) -> Result<T,RequestError> {
    switch response {
      case .success(let data):
        if let decodedData = decodeData(responseModel: responseModel, data) {
          return .success(decodedData)
        } else {
          return .failure(.decodeFailed)
        }
      case .failure(let failure):
        return .failure(failure)
    }
  }

  private func handleRequestResponse(response: Result<Data,RequestError>) -> Result<Void,RequestError> {
    switch response {
      case .success(let data):
        if data.isEmpty {
          return .success(())
        } else {
          return .failure(.decodeFailed)
        }
      case .failure(let failure):
        return .failure(failure)
    }
  }

  private func decodeData<T:Decodable>(responseModel: T.Type, _ data: Data) -> T? {
    guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
      return nil
    }

    return decodedData
  }
}
