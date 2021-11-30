import SwiftUI
import SpriteKit

struct ContentView: View {
  @State private var crownPosition = 0.0

  var body: some View {
    GeometryReader { reader in
      SpriteView(scene: PongScene(size: reader.size, crownPosition: $crownPosition))
        .focusable()
        .digitalCrownRotation($crownPosition)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
