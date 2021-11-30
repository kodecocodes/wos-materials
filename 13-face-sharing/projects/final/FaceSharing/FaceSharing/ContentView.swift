import SwiftUI
import ClockKit

struct ContentView: View {
  @EnvironmentObject private var session: Session

  var body: some View {
    VStack {
      Image("FacePreview")

      if session.showFaceSharing {
        Button {
          Task { await sendWatchFace() }
        } label: {
          Image("ShareButton")
        }
      } else {
        Text("Unable to share watch face")
          .font(.title)
        Text("Please pair an Apple Watch first")
          .font(.title3)
      }
    }
  }

  func sendWatchFace() async {
    guard let url = Bundle.main.url(
      forResource: "FaceToShare",
      withExtension: "watchface"
    ) else {
      fatalError("You didn't include the watchface file in the bundle.")
    }

    let library = CLKWatchFaceLibrary()
    do {
      try await library.addWatchFace(at: url)
    } catch {
      print(error.localizedDescription)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
