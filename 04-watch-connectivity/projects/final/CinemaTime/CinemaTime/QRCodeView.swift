import SwiftUI

struct QRCodeView: View {
  let movie: Movie

  var body: some View {
    GeometryReader { reader in
      if let image = QRCode.generate(movie: movie, size: reader.size) {
        Image(uiImage: image)
      } else {
        Image(systemName: "xmark.circle")
      }
    }
  }
}

struct QRCodeView_Previews: PreviewProvider {
  static var previews: some View {
    QRCodeView(movie: Movie.forPreview())
      .frame(width: 200, height: 200)
  }
}
