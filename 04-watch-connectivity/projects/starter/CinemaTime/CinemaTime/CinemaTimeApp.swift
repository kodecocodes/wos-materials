import SwiftUI

@main
struct CinemaTimeApp: App {
  init() {
    UINavigationBar.appearance().barTintColor = UIColor(red: 157 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1)
    UITableView.appearance().backgroundColor = UIColor(.background)
    UITableViewCell.appearance().backgroundColor = UIColor(.background)
  }

  var body: some Scene {
    WindowGroup {
      PurchasedTicketsListView()
    }
  }
}
