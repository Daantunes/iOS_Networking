import Foundation

class NewRequestManager {

  // MARK: - Properties -

  private let session = URLSession(configuration: .default)
  private var dataTask: URLSessionDataTask?

  // MARK: - Methods -

  func sendRequest(router: NewRouter, completion: @escaping (Result<Data, RequestError>) -> Void
  ) {
    guard let request = router.urlRequest() else {
      completion(.failure(.invalidURL))

      return
    }

    dataTask = session.dataTask(with: request) { data, response, error in
      defer {
        self.dataTask = nil
      }

      let handledResponse = self.handleResponse(data: data, response: response, error: error)

      completion(handledResponse)
    }

    dataTask?.resume()
  }

  private func handleResponse(
    data: Data?,
    response: URLResponse?,
    error: Error?
  ) -> Result<Data, RequestError> {
    if let error = error {
      return .failure(.error(error))
    }

    guard let response = response as? HTTPURLResponse else {
      return .failure(.noResponse)
    }

    switch response.statusCode {
      case 200...299:
        if let data = data {
          return .success(data)
        } else {
          return .failure(.noData)
        }
      case 400:
        return .failure(.badRequest)
      case 401:
        Session.shared.signOut()
        return .failure(.unauthorized)
      case 404:
        return .failure(.notFound)
      default:
        return .failure(.unexpectedStatusCode(response.statusCode))
    }
  }
}
