import SwiftUI
import WidgetKit

struct AccessoryInlineView: View {
  let tide: Tide?

  var body: some View {
    if let tide {
      ViewThatFits {
        Text("\(tide.heightString()) and \(tide.type.rawValue) as of \(tide.date.formatted(date: .omitted, time: .shortened))")
        Text("\(tide.heightString()), \(tide.type.rawValue), \(tide.date.formatted(date: .omitted, time: .shortened))")
        Text("\(tide.heightString()), \(tide.type.rawValue)")
        Text(tide.heightString())
      }
    } else {
      Text("No data")
    }
  }
}

struct AccessoryInline_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AccessoryInlineView(tide: Tide.placeholder())
        .previewContext(WidgetPreviewContext(family: .accessoryInline))

      AccessoryInlineView(tide: nil)
        .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }
  }
}
