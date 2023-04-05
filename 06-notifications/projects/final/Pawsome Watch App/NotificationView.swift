import SwiftUI

struct NotificationView: View {
  // 1
  let message: String
  let image: Image

  // 2
  var body: some View {
    ScrollView {
      Text(message)
        .font(.headline)

      image
        .resizable()
        .scaledToFit()
    }
  }
}

struct NotificationView_Previews: PreviewProvider {
  static var previews: some View {
    // 3
    NotificationView(
      message: "Awww",
      image: Image("cat\(Int.random(in: 1...20))")
    )
  }
}
