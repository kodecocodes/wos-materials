import Foundation
import ClockKit

struct ModularLarge: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateModularLargeTallBody(
      headerTextProvider: .init(format: "Temperature"),
      bodyTextProvider: textProvider(for: temperature)
    )
  }
}
