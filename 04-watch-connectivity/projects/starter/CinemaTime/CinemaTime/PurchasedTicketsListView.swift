import SwiftUI

struct PurchasedTicketsListView: View {
  @ObservedObject private var ticketOffice = TicketOffice.shared

  var body: some View {
    NavigationView {
      List {
        ForEach(ticketOffice.purchased) { movie in
          NavigationLink(destination: MovieDetailsView(movie: movie)) {
            MovieRow(movie: movie)
          }
          .listRowBackground(Color.background)
        }
        .onDelete(perform: delete)

        NavigationLink(destination: MoviesListView()) {
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
