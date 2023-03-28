import SwiftUI

struct MovieDetailsView: View {
  let movie: Movie

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Image(movie.poster)
          .resizable()
          .frame(width: 120, height: 200)
          .scaledToFit()

        MovieInfoView(movie: movie)
      }

      Text(movie.synopsis)
        .font(.subheadline)
        .foregroundColor(.text)

      VStack(alignment: .center) {
        if TicketOffice.shared.isPurchased(movie) {
          QRCodeView(movie: movie)
            .frame(width: 200, height: 200)
            .padding(.top)

          Spacer()
        } else {
          Spacer()

          PurchaseTicketView(movie: movie)
        }
      }
      .frame(maxWidth: .infinity)
      .padding()
    }
    .padding()
    .background(Color.background)
    .edgesIgnoringSafeArea(.bottom)
  }
}

struct MovieDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    MovieDetailsView(movie: Movie.forPreview())
  }
}
