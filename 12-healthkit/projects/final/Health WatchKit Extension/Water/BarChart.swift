import SwiftUI
import SwiftUICharts

struct BarChart: View {
  private let legend = Legend(color: .blue, label: "Consumed")
  private let points: [DataPoint]?
  private let style = BarChartStyle(showLegends: false)

  init(data: [WaterGraphData]?) {
    guard let data = data else {
      points = nil
      return
    }

    var points: [DataPoint] = []

    for element in data {
      let point = DataPoint(
        value: element.value,
        label: LocalizedStringKey(element.symbol),
        legend: legend
      )

      points.append(point)
    }

    self.points = points
  }

  var body: some View {
    if let points = points {
      BarChartView(dataPoints: points, limit: nil)
        .chartStyle(style)
    } else {
      EmptyView()
    }
  }
}

struct BarChart_Previews: PreviewProvider {
  static var previews: some View {
    BarChart(data: [
      WaterGraphData(value: 104, symbol: "S"),
      WaterGraphData(value: 105, symbol: "M"),
      WaterGraphData(value: 300, symbol: "T"),
      WaterGraphData(value: 400, symbol: "W"),
      WaterGraphData(value: 500, symbol: "T"),
      WaterGraphData(value: 600, symbol: "F"),
      WaterGraphData(value: 700, symbol: "S"),
    ])
  }
}
