import SwiftUI

struct WidgetEntryView : View {
  @Environment(\.widgetFamily) var family

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
      AccessoryInline(tide: entry.tide)
        .widgetURL(url())

    case .accessoryRectangular:
      AccessoryRectangular(tide: entry.tide)
        .widgetURL(url())

    @unknown default:
      Text("Unsupported widget")
    }
  }

  private func url() -> URL {
    guard let stationId = entry.configuration.station?.identifier else {
      fatalError()
    }

    return URL(string: "tidewatch://station/\(stationId)")!
  }
}
