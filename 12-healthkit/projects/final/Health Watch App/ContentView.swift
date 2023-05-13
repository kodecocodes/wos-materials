import SwiftUI
import HealthKit

struct ContentView: View {
  @State private var wantsToBrush = false
  @State private var isGettingReady = false
  @State private var wantsToDrink = false
  @State private var waitingForHealthKit = true

  private let healthStoreLoaded = NotificationCenter.default.publisher(
    for: .healthStoreLoaded
  )

  private let stopBrushing = NotificationCenter.default.publisher(for: .dismissSheets)

  var body: some View {
    VStack {
      if waitingForHealthKit {
        Text("Waiting for HealthKit prompt.")
      } else {
        Button("Brush") {
          isGettingReady.toggle()
        }

        if HealthStore.shared.isWaterEnabled {
          Button {
            wantsToDrink.toggle()
          } label: {
            Image(systemName: "drop.fill")
              .foregroundColor(.blue)
          }
        }
      }
    }
    .padding()
    .sheet(isPresented: $wantsToBrush) {
      BrushingTimerView()
    }
    .sheet(isPresented: $wantsToDrink) {
      WaterView()
    }
    .overlay(
      VStack {
        if isGettingReady {
          GetReadyView {
            wantsToBrush.toggle()
          }
          .frame(width: 125, height: 125)
          .padding()
        } else {
          EmptyView()
        }
      }
    )
    .onReceive(stopBrushing) { _ in
      isGettingReady = false
      wantsToBrush = false
    }
    .onReceive(healthStoreLoaded) { _ in
      self.waitingForHealthKit = false
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
