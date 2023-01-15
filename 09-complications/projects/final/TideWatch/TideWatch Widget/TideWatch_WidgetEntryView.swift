import SwiftUI

struct TideWatch_WidgetEntryView : View {
  @Environment(\.widgetFamily) var widgetFamily

  let entry: Provider.Entry

  var body: some View {
    if entry.tide.hasData == false {
      Text("No data")
        .widgetURL(url())
    } else {
      switch widgetFamily {
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
        AccessoryRectangularView(tide: entry.tide, stationName: entry.configuration.station!.displayString)
          .widgetURL(url())

      @unknown default:
        Text("Unknown family")
      }
    }
  }

  func url() -> URL? {
    guard
      let stationId = entry.configuration.station?.identifier,
      let url = URL(string: "tidewatch://station/\(stationId)")
    else {
      return nil
    }

    return url
  }
}
