import SwiftUI

struct ContentView: View {
  var body: some View {
    List(1..<21) { i in
      Image("cat\(i)")
        .resizable()
        .scaledToFit()
    }
    .listStyle(CarouselListStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
