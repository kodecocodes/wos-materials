import SwiftUI

struct ContentView: View {
  @State private var number = 0.0

  var body: some View {
    Text(number.formatted(.number))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
