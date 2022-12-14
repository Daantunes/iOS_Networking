import Foundation
import Moya

struct RequestManagerWithMoya {

  // MARK: - Properties -

  private let provider = MoyaProvider<RouterWithMoya>()

  // MARK: - Methods -

  func sendRequest<T: Decodable> (
    router: RouterWithMoya,
    responseModel: T.Type,
    completion: @escaping (Result<T, RequestError>) -> Void
  ) {
    provider.request(router) { result in
      switch result {
        case .success(let response):
          if response.statusCode == 401 {
            Session.shared.signOut()
            break
          }
          do {
            completion(.success(try JSONDecoder().decode(T.self, from: response.data)))
          } catch {
            completion(.failure(.decodeFailed))
          }
        case .failure(let error):
          completion(.failure(.error(error as NSError)))
      }
    }
  }

  func sendRequest(router: RouterWithMoya, completion: @escaping (Result<Void, RequestError>) -> Void ) {
    provider.request(router) { result in
      switch result {
        case .success:
          completion(.success(()))
        case .failure(let error):
          completion(.failure(.error(error as NSError)))
      }
    }
  }
}
