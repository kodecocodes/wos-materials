import SwiftUI
import WidgetKit

struct AccessoryInlineView: View {
  let tide: Tide

  var body: some View {
    let height = tide.heightString()
    let type = tide.type.rawValue.capitalized

    ViewThatFits {
      Text("\(height), \(type) @ \(tide.date, style: .time)")
      Text("\(height), \(type)")
      Text(height)
    }
  }
}

struct AccessoryInlineView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryInlineView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryInline))
  }
}
