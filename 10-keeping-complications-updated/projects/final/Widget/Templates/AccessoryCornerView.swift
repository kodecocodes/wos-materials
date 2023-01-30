import SwiftUI
import WidgetKit

struct AccessoryCornerView: View {
  let tide: Tide?

  var body: some View {
    ZStack {
      AccessoryWidgetBackground()
      image()
        .font(.title.bold())
    }
    .widgetLabel {
      Text(label())
        .foregroundColor(.blue)
    }
  }

  func image() -> Image {
    if let tide {
      return tide.image()
    } else {
      return Image(systemName: "questionmark.circle")
    }
  }

  func label() -> String {
    if let tide {
      return tide.heightString(unitStyle: .long)
    } else {
      return "No data"
    }
  }
}

struct AccessoryCornerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AccessoryCornerView(tide: Tide.placeholder())
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))

      AccessoryCornerView(tide: nil)
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))
    }
  }
}
