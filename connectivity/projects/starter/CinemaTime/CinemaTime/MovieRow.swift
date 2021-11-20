import SwiftUI

struct MovieRow: View {
  let movie: Movie

  var body: some View {
    HStack(alignment: .top) {
      Image(movie.poster)
        .resizable()
        .scaledToFit()
        .frame(width: 70)

      VStack(alignment: .leading) {
        Text(movie.title)
          .font(.headline)
          .foregroundColor(.header)

        Text(movie.synopsis)
          .font(.caption)
          .foregroundColor(.text)
          .lineLimit(5)
      }
    }
  }
}

struct MovieRow_Previews: PreviewProvider {
  static var previews: some View {
    List {
      MovieRow(movie: Movie.forPreview())
        .listRowBackground(Color.background)
    }
  }
}
