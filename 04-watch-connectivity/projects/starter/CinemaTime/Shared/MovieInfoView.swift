import SwiftUI

struct MovieInfoView: View {
  let movie: Movie

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(movie.title)
        .font(.headline)
        .foregroundColor(.white)

      Text("Time: \(movie.time)")
        .foregroundColor(.text)

      Text("Director:")
        .foregroundColor(.header)

      Text(movie.director)
        .foregroundColor(.text)

      Text("Actors:")
        .foregroundColor(.header)

      Text(movie.actors)
        .foregroundColor(.text)
    }
    .font(.subheadline)
  }
}

struct MovieInfoView_Previews: PreviewProvider {
  static var previews: some View {
    MovieInfoView(movie: Movie.forPreview())
      .background(Color.background)
  }
}
