import SwiftUI

struct EntryView : View {
  @Environment(\.widgetFamily) private var family

  var entry: Provider.Entry

  var body: some View {
    switch family {
    case .accessoryCircular:
      AccessoryCircularView(tide: entry.tide)

    case .accessoryCorner:
      AccessoryCornerView(tide: entry.tide)

    case .accessoryInline:
      AccessoryInlineView(tide: entry.tide)

    case .accessoryRectangular:
      AccessoryRectangularView(tide: entry.tide)

    @unknown default:
      Text("Unsupported widget")
    }
  }
}
