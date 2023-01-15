import Foundation

struct TidePredictions: Decodable {
  let predictions: [TidePrediction]?
  let error: [String: String]?
}
