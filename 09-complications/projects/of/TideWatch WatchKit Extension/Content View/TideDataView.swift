import SwiftUI

struct TideDataView: View {
  let title: String
  let value: String?

  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
        .foregroundColor(.white)

      Spacer()

      Text(value ?? "--")
        .font(.body)
        .foregroundColor(.text)
    }
  }
}

struct TideInformation_Previews: PreviewProvider {
  static var previews: some View {
    TideDataView(title: "Water Level", value: "2.3'")
  }
}
