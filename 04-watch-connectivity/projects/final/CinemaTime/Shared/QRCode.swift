import SwiftUI
#if canImport(CoreImage)
import CoreImage.CIFilterBuiltins
#endif

enum QRCode {
#if canImport(CoreImage)
  static func generate(movie: Movie, size: CGSize) -> UIImage? {
    let filter = CIFilter.qrCodeGenerator()
    filter.message = Data("\(movie.title) @ \(movie.time)".utf8)
    filter.correctionLevel = "Q"

    if let output = filter.outputImage {
      let x = size.width / output.extent.size.width
      let y = size.height / output.extent.size.height

      let scaled = output.transformed(by: CGAffineTransform(scaleX: x, y: y))
      if let cgImage = CIContext().createCGImage(scaled, from: scaled.extent) {
        return UIImage(cgImage: cgImage)
      }
    }

    return nil
  }
#endif

#if os(watchOS)
static func url(for movieId: Int) -> URL {
  let documents = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  )[0]

  return documents.appendingPathComponent("\(movieId).png")
}
#endif

}
