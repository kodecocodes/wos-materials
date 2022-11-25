import SwiftUI

struct PurchasedTicketsListView: View {
  @ObservedObject private var ticketOffice = TicketOffice.shared

  var body: some View {
    List {
      ForEach(ticketOffice.purchased) { movie in
        NavigationLink(destination: MovieDetailsView(movie: movie)) {
          MovieRow(movie: movie)
        }
      }
      .onDelete(perform: delete)

      NavigationLink(destination: MoviesListView()) {
        Image("purchase_tickets")
          .resizable()
          .scaledToFit()
          .padding()
      }
    }
    .navigationBarTitle("Purchased Tickets")
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
