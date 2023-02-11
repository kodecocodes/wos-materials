import SwiftUI

struct ContentView: View {
  @State private var isPresented = false
  @State private var selectedStation = MeasurementStation.allStations[0]
  @State private var isLoading = false

  @StateObject private var model = ContentModel()

  var body: some View {
    VStack {
      Text(model.station.name)
        .foregroundColor(.title)
        .font(.headline)
        .onTapGesture {
          selectedStation = model.station
          isPresented.toggle()
        }

      Text(model.station.state)
        .foregroundColor(.text)
        .font(.subheadline)

      Image("waves")
        .padding(.bottom)

      if let tide = model.currentWaterLevel {
        TideDataView(title: "Water Level", value: tide.heightString())
        TideDataView(title: "\(CoOpsApi.shared.averageHourString) Average", value: model.averageWaterLevel)
          .padding(.bottom)
        TideDataView(title: "Tide", value: tide.type.rawValue.capitalized)
      } else if isLoading {
        ProgressView()
      }
    }
    .sheet(isPresented: $isPresented) {
      Picker("Please choose a station", selection: $selectedStation) {
        ForEach(MeasurementStation.allStations, id: \.self) {
          Text($0.name)
        }
      }
      .onTapGesture {
        Task { await model.fetch(newStation: selectedStation) }
        isPresented.toggle()
      }
    }
    .task {
      isLoading = true
      await model.fetch()
      isLoading = false
    }
    .onOpenURL { url in
      let stationId = url.lastPathComponent

      guard
        url.scheme == "tidewatch",
        url.host == "station",
        stationId != "/",
        !stationId.isEmpty
      else {
        return
      }

      if let station = MeasurementStation.station(for: stationId) {
        Task { await model.fetch(newStation: station) }
      }
    }
  }
}
