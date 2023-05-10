import SwiftUI
import ClockKit

struct ContentView: View {
  @State private var wantsToBrush = false
  @State private var isGettingReady = false

  private let stopBrushing = NotificationCenter.default.publisher(for: .dismissSheets)

  var body: some View {
    VStack {
      Button("Brush") {
        isGettingReady.toggle()
      }
    }
    .padding()
    .sheet(isPresented: $wantsToBrush) {
      BrushingTimerView()
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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
