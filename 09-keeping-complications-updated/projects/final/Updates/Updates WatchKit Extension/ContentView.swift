import SwiftUI

struct ContentView: View {
  @State private var downloader = UrlDownloader(identifier: "ContentView")

  var body: some View {
    Button {
      downloader.schedule(firstTime: true)
    } label: {
      Text("Download")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
