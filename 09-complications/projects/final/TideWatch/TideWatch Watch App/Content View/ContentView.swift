import SwiftUI

struct ContentView: View {
  @Environment(\.scenePhase) private var scenePhase

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
    .onChange(of: scenePhase) { phase in
      guard phase == .active else { return }

      getTides(station: model.station)
    }
    .onOpenURL { url in
      guard
        url.scheme == "tidewatch",
        url.host == "station",
        url.pathComponents.count == 2,
        let station = MeasurementStation.station(for: url.pathComponents[1])
      else {
        return
      }

      model.station = station

      getTides(station: station)
    }
    .sheet(isPresented: $isPresented) {
      Picker("Please choose a station", selection: $selectedStation) {
        ForEach(MeasurementStation.allStations, id: \.self) {
          Text($0.name)
        }
      }
      .onTapGesture {
        getTides(station: selectedStation)
        isPresented.toggle()
      }
    }
  }

  private func getTides(station: MeasurementStation) {
    let lastDownload = UserDefaults.standard.double(forKey: station.id)

    guard lastDownload + 1800 < Date.now.timeIntervalSince1970 else { return }

    Task {
      await MainActor.run { self.isLoading = true }
      await self.model.fetch(newStation: station)

      UserDefaults.standard.set(Date.now.timeIntervalSince1970, forKey: station.id)

      await MainActor.run { self.isLoading = false }
    }
  }
}

