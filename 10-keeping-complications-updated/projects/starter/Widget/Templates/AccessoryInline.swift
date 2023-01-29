import SwiftUI
import WidgetKit

struct AccessoryInline: View {
  let tide: Tide

  var body: some View {
    ViewThatFits {
      Text("\(tide.heightString()) and \(tide.type.rawValue) as of \(tide.date.formatted(date: .omitted, time: .shortened))")
      Text("\(tide.heightString()), \(tide.type.rawValue), \(tide.date.formatted(date: .omitted, time: .shortened))")
      Text("\(tide.heightString()), \(tide.type.rawValue)")
      Text(tide.heightString())
    }
  }
}

struct AccessoryInline_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryInline(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryInline))
  }
}
