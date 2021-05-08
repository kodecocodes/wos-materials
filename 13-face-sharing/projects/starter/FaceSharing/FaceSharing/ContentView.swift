import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var session: Session

  var body: some View {
    VStack {
      Image("FacePreview")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
