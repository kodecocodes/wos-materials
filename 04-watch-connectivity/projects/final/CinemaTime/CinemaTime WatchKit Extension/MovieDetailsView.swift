import SwiftUI

struct MovieDetailsView: View {
  let movie: Movie

  var body: some View {
    ScrollView {
      MovieInfoView(movie: movie)

      if !TicketOffice.shared.isPurchased(movie) {
        PurchaseTicketView(movie: movie)
      } else {
        movie.qrCodeImage()
      }
    }
  }
}

struct MovieDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    MovieDetailsView(movie: Movie.forPreview())
  }
}
