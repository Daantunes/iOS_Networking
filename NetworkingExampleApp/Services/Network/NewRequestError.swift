import Foundation

enum RequestErrorType: Error {
  case invalidURL
  case decodeFailed
  case noResponse
  case requestError(RequestErrorCode)
  case unexpectedStatusCode(_ code: Int)
  case unknown
}

enum RequestErrorCode: Int {
  case badRequest = 400
  case noData = 204
  case notFound = 404
  case unauthorized = 401
}
