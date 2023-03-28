import SwiftUI

struct ProtectedView: View {
  var body: some View {
    Text("This cool view is protected. If you see it, you must be authenticated.")
  }
}

struct ProtectedView_Previews: PreviewProvider {
  static var previews: some View {
    ProtectedView()
  }
}
