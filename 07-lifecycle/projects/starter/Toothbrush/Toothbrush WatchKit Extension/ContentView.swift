import SwiftUI

struct ContentView: View {
  @Environment(\.scenePhase) private var scenePhase

  var body: some View {
    Text("Hello, World!")
    .onChange(of: scenePhase) { print($0) }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
