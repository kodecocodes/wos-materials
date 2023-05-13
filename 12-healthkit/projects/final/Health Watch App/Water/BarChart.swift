import SwiftUI
import Charts

struct BarChart: View {
  let data: [WaterGraphData]?

  var body: some View {
    if let data {
      Chart(data) {
        BarMark(
          x: .value("Day", $0.symbol),
          y: .value("Height", $0.value)
        )
      }
    } else {
      EmptyView()
    }
  }
}

struct BarChart_Previews: PreviewProvider {
  static var previews: some View {
    BarChart(data: [
      WaterGraphData(value: 104, symbol: "Sun"),
      WaterGraphData(value: 105, symbol: "Mon"),
      WaterGraphData(value: 300, symbol: "Tue"),
      WaterGraphData(value: 400, symbol: "Wed"),
      WaterGraphData(value: 500, symbol: "Thu"),
      WaterGraphData(value: 600, symbol: "Fri")
    ])
  }
}
