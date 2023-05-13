import SwiftUI
import HealthKit

struct WaterView: View {
  @State private var consumed = ""
  @State private var percent = ""
  @State private var graphData: [WaterGraphData]?

  var body: some View {
    ScrollView {
      VStack {
        if HealthStore.shared.isWaterEnabled {
          Text("Add water")
            .font(.headline)

          HStack {
            LogWaterButton(size: .small) { logWater(quantity: $0) }
            LogWaterButton(size: .large) { logWater(quantity: $0) }
          }
          .padding(.bottom)

          HStack {
            Text("Today:")
              .font(.headline)
            Text(consumed)
              .font(.body)
          }

          HStack {
            Text("Goal:")
              .font(.headline)
            Text(percent)
              .font(.body)
          }

          BarChart(data: graphData)
            .padding()
        } else {
          Text("Please enable water tracking in Apple Health.")
        }
      }
    }
    .task {
      await updateStatus()
      try? HealthStore.shared.waterConsumptionGraphData() {
        self.graphData = $0
      }
    }
  }

  private func logWater(quantity: HKQuantity) {
    Task {
      try await HealthStore.shared.logWater(quantity: quantity)
      await updateStatus()
    }
  }

  @MainActor
  private func updateStatus() async {
    guard
      let (measurement, percent) = try? await HealthStore.shared.currentWaterStatus()
    else {
      consumed = "0"
      percent = "Unknown"
      return
    }

    consumed = consumedFormat.string(from: measurement)

    self.percent = percent?
      .formatted(.percent.precision(.fractionLength(0))) ?? "Unknown"
  }
}

struct WaterView_Previews: PreviewProvider {
  static var previews: some View {
    WaterView()
  }
}

private let consumedFormat: MeasurementFormatter = {
  var fmt = MeasurementFormatter()
  fmt.unitOptions = .naturalScale
  return fmt
}()
