import SwiftUI

@main
struct CinemaTimeApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        PurchasedTicketsListView()
      }
    }
  }
}
