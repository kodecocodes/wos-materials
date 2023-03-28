import Foundation

struct Team: Equatable {
  let name: String
  
  var logoName: String {
    return name.replacingOccurrences(of: " ", with: "-").lowercased()
  }
}
