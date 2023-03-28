import SwiftUI

struct MovieRow: View {
  let movie: Movie

  var body: some View {
    Text(movie.title)
      .font(.subheadline)
      .foregroundColor(.text)
  }
}

struct MovieRow_Previews: PreviewProvider {
  static var previews: some View {
    MovieRow(movie: Movie.forPreview())
  }
}
