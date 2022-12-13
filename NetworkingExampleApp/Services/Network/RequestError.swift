import Foundation

enum RequestError: Error {
  case badRequest
  case decodeFailed
  case error(Error)
  case invalidURL
  case noResponse
  case notFound
  case unexpectedStatusCode(_ code: Int)
  case unauthorized
  case unknown(HTTPURLResponse?)
}
