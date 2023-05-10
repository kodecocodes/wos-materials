import Foundation

struct TidePrediction: Decodable {
  let date: Date
  let height: Double

  private enum CodingKeys: String, CodingKey {
    case date = "t"
    case height = "v"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    date = try values.decode(Date.self, forKey: .date)

    let str = try values.decode(String.self, forKey: .height)
    height = Double(str) ?? 0
  }
}
