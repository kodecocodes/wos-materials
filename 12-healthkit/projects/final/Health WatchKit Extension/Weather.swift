import Foundation

struct Period: Decodable {
  let temperature: Int
}

struct Properties: Decodable {
  let periods: [Period]
}

struct Weather: Decodable {
  let properties: Properties
}
