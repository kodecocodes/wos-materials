import SwiftUI
import CoreImage.CIFilterBuiltins

enum QRCode {
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
}
