import SwiftUI

struct MoviesListView: View {
  @ObservedObject private var ticketOffice = TicketOffice.shared
  @State private var selection: Int?

  private let purchasableMovies = TicketOffice.shared.purchasableMovies()

  var body: some View {
    List {
      ForEach(purchasableMovies.keys.sorted(), id: \.self) { title in
        Section(header: Text(title)) {
          ForEach(purchasableMovies[title]!.sorted(by: { $0.title < $1.title })) { movie in
            NavigationLink(value: movie) {
              MovieRow(movie: movie)
            }
          }
        }
      }
      .listRowBackground(Color.background)
    }
    .background(Color.background)
  }
}

struct MoviesListView_Previews: PreviewProvider {
  static var previews: some View {
    MoviesListView()
  }
}
