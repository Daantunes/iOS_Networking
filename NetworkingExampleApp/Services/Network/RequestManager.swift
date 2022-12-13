import Foundation

class RequestManager {

  // MARK: - Properties -

  private let session = URLSession(configuration: .default)
  private var dataTask: URLSessionDataTask?

  // MARK: - Methods -

  func sendRequest<T: Decodable> (
    router: Router,
    responseModel: T.Type,
    completion: @escaping (Result<T, RequestError>) -> Void
  ) {
    guard let request = router.urlRequest() else {
      completion(.failure(.invalidURL))

      return
    }

    dataTask = session.dataTask(with: request) { data, response, error in
      defer {
        self.dataTask = nil
      }

      let handledResponse = self.handleResponse(
        data: data,
        response: response,
        error: error,
        responseModel: T.self
      )

      completion(handledResponse)
    }

    dataTask?.resume()
  }

  func sendRequest(router: Router, completion: @escaping (Result<Void, RequestError>) -> Void ) {
    guard let request = router.urlRequest() else {
      completion(.failure(.invalidURL))

      return
    }

    dataTask = session.dataTask(with: request) { data, response, error in
      defer {
        self.dataTask = nil
      }

      let handledResponse = self.handleResponse(
        data: data,
        response: response,
        error: error
      )

      completion(handledResponse)
    }

    dataTask?.resume()
  }
}

extension RequestManager {
  private func handleResponse<T: Decodable>(
    data: Data?,
    response: URLResponse?,
    error: Error?,
    responseModel: T.Type
  ) -> Result<T, RequestError> {
    if let error = error {
      return .failure(.error(error))
    }

    guard let response = response as? HTTPURLResponse else {
      return .failure(.noResponse)
    }

    switch response.statusCode {
      case 200...299:
        if let data = data {
          do {
            let decodedData = try JSONDecoder().decode(responseModel.self, from: data)

            return .success(decodedData)
          } catch {
            return .failure(.decodeFailed)
          }
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

    return .failure(.unknown(response))
  }

  private func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<Void, RequestError> {
    if let error = error {
      return .failure(.error(error))
    }

    guard let response = response as? HTTPURLResponse else {
      return .failure(.noResponse)
    }

    switch response.statusCode {
      case 200...299:
        if let data = data {
          if data.isEmpty {
            return .success(())
          } else {
            return .failure(.decodeFailed)
          }
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

    return .failure(.unknown(response))
  }
}
