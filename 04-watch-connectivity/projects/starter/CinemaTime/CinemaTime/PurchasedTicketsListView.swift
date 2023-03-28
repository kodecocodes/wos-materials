import SwiftUI

struct PurchasedTicketsListView: View {
  @ObservedObject private var ticketOffice = TicketOffice.shared

  var body: some View {
    NavigationStack {
      List {
        ForEach(ticketOffice.purchased) { movie in
          NavigationLink(value: movie) {
            MovieRow(movie: movie)
          }
          .listRowBackground(Color.background)
        }
        .onDelete(perform: delete)

        NavigationLink(value: "movie_list") {
          Image("purchase_tickets")
            .resizable()
            .scaledToFit()
            .padding()
        }
        .isDetailLink(false)
        .listRowBackground(Color.background)
        .padding(.top)
      }
      .navigationBarTitle("Purchased Tickets")
      .navigationBarTitleDisplayMode(.inline)
      .navigationDestination(for: Movie.self) { movie in
          MovieDetailsView(movie: movie)
      }
      .navigationDestination(for: String.self) { _ in
          MoviesListView()
      }
    }
  }

  private func delete(at offsets: IndexSet) {
    withAnimation {
      TicketOffice.shared.delete(at: offsets)
    }
  }
}

struct TicketsListView_Previews: PreviewProvider {
  static var previews: some View {
    PurchasedTicketsListView()
  }
}
