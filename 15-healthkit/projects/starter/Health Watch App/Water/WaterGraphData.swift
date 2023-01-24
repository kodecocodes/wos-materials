import Foundation

struct WaterGraphData: Identifiable {
  let id = UUID()
  let value: Double
  let symbol: String

  init(_ value: Double, for day: Date) {
    let dayNumber = Calendar.current.component(.weekday, from: day) - 1

    self.symbol = Calendar.current.shortStandaloneWeekdaySymbols[dayNumber]
    self.value = value
  }

  // Only here for preview support
  init(value: Double, symbol: String) {
    self.value = value
    self.symbol = symbol
  }
}
