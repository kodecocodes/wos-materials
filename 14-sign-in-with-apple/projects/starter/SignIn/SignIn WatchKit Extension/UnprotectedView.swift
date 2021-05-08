import SwiftUI

struct UnprotectedView: View {
  var body: some View {
    Text("This cool view is visible to anyone. No login required!")
  }
}

struct NoLoginView_Previews: PreviewProvider {
  static var previews: some View {
    UnprotectedView()
  }
}
