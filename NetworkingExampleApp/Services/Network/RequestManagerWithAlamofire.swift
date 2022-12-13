import Alamofire
import Foundation

struct RequestManagerWithAlamofire {

  // MARK: - Methods -

  func sendRequest<T: Decodable> (
    router: Router,
    responseModel: T.Type,
    completion: @escaping (Result<T, RequestError>) -> Void
  ) {
    guard let requestURL = router.urlRequest() else {
      completion(.failure(.invalidURL))

      return
    }

    AF.request(requestURL, interceptor: self)
      .validate()
      .responseDecodable(of: T.self) { response in
        switch response.result {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            completion(.failure(.error(error as NSError)))
        }
      }
  }

  func sendRequest(router: Router, completion: @escaping (Result<Void, RequestError>) -> Void ) {
    guard let requestURL = router.urlRequest() else {
      completion(.failure(.invalidURL))

      return
    }

    AF.request(requestURL, interceptor: self)
      .validate()
      .response { response in
        switch response.result {
          case .success:
            completion(.success(()))
          case .failure(let error):
            completion(.failure(.error(error as NSError)))
        }
      }
  }
}

// MARK: - RequestInterceptor -

extension RequestManagerWithAlamofire: RequestInterceptor {
  func retry(
    _ request: Request,
    for session: Alamofire.Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    if request.response?.statusCode == 401 {
      Session.shared.signOut()
    }
  }
}
