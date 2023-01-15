import SwiftUI

struct ContentView: View {
  @State private var isActive = false
  @State private var mustAuthenticate = false

  var body: some View {
    NavigationStack {
      VStack {
        NavigationLink("No login required", destination: UnprotectedView())

        Button {
          mustAuthenticate = true
        } label: {
          Text("Login required")
        }
      }
      .navigationBarTitle("Choose")
      .navigationDestination(isPresented: $isActive) {
        ProtectedView()
      }
      .sheet(isPresented: $mustAuthenticate) {
        SignInView { _ in isActive = true }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
