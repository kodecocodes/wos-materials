import Foundation

struct WaterGraphData: Identifiable {
  let id = UUID()
  var value = 0.0
  let symbol: String

  init(for day: Date) {
    let dayNumber = Calendar.current.component(.weekday, from: day) - 1

    self.symbol = Calendar.current.veryShortStandaloneWeekdaySymbols[dayNumber]
  }

  init(value: Double, symbol: String) {
    self.value = value
    self.symbol = symbol
  }
}
