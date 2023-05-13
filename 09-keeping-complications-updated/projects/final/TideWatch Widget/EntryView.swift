import SwiftUI

struct EntryView : View {
  @Environment(\.widgetFamily) private var family

  var entry: Provider.Entry

  var body: some View {
    switch family {
    case .accessoryCircular:
      AccessoryCircularView(tide: entry.tide)
        .widgetURL(url())

    case .accessoryCorner:
      AccessoryCornerView(tide: entry.tide)
        .widgetURL(url())

    case .accessoryInline:
      AccessoryInlineView(tide: entry.tide)
        .widgetURL(url())

    case .accessoryRectangular:
      AccessoryRectangularView(
        tide: entry.tide,
        stationName: entry.configuration.station?.displayString
      )
      .widgetURL(url())

    @unknown default:
      Text("Unsupported widget")
    }
  }

  private func url() -> URL {
    guard let stationId = entry.configuration.station?.identifier else {
      return URL(string: "tidewatch://station/NOTASTATION")!
    }

    return URL(string: "tidewatch://station/\(stationId)")!
  }
}
