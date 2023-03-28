import SwiftUI

struct PurchaseTicketView: View {
  @State private var isPresented = false

  let movie: Movie

  var body: some View {
    if TicketOffice.shared.isPurchased(movie) {
      EmptyView()
    } else {
      Button(
        action: { isPresented = true },
        label: {
          Image("purchase_tickets")
            .resizable()
            .scaledToFit()
        })
      .actionSheet(isPresented: $isPresented) {
        ActionSheet(
          title: Text("Purchase Ticket"),
          message: Text("Are you sure you want to purchase 1 ticket for \(TicketOffice.shared.ticketCost)?"),
          buttons: [
            .cancel(),
            .default(Text("Buy")) {
              TicketOffice.shared.purchase(movie)
            }
          ])
      }
    }
  }
}

struct PurchaseTicketView_Previews: PreviewProvider {
  static var previews: some View {
    PurchaseTicketView(movie: Movie.forPreview())
  }
}
