import SwiftUI

struct ContentView: View {
  @State private var isActive = false
  @State private var mustAuthenticate = false
  
  var body: some View {
    VStack {
      NavigationLink("No login required", destination: UnprotectedView())
      
      NavigationLink(destination: ProtectedView(), isActive: $isActive) {
        EmptyView()
      }
      .frame(width: 0, height: 0)
      
      Button("Login required", action: pushIfAuthenticated)
    }
    .navigationBarTitle("Choose")
    .sheet(isPresented: $mustAuthenticate) {
      SignInView { _ in isActive = true }
    }
  }
  
  private func pushIfAuthenticated() {
    mustAuthenticate = true
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
