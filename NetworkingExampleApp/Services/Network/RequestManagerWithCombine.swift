import Combine
import Foundation

class RequestManagerWithCombine {

  // MARK: - Methods -

  func sendRequest(router: Router) -> AnyPublisher<Data,RequestErrorType> {
    guard let request = router.urlRequest() else {
      return Fail(error: .invalidURL).eraseToAnyPublisher()
    }

    return URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap() { data, response in
        guard let httpResponse = response as? HTTPURLResponse else {
          throw RequestErrorType.noResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
          return data
        } else if let code = RequestErrorCode(rawValue: httpResponse.statusCode) {
          throw RequestErrorType.requestError(code)
        } else {
          throw RequestErrorType.unexpectedStatusCode(httpResponse.statusCode)
        }
      }
      .mapError { $0 as? RequestErrorType ?? RequestErrorType.unknown }
      .eraseToAnyPublisher()
  }
}
