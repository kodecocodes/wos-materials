import Foundation
import ClockKit

struct ModularLarge: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    let date = waterLevel.date
      .formatted(.dateTime
                  .year(.defaultDigits)
                  .month(.defaultDigits)
                  .day(.defaultDigits)
      )

    return CLKComplicationTemplateModularLargeColumns(
      row1Column1TextProvider: .init(format: "Date"),
      row1Column2TextProvider: .init(format: date),
      row2Column1TextProvider: .init(format: "Level"),
      row2Column2TextProvider: textProvider(for: waterLevel),
      row3Column1TextProvider: .init(format: "Type"),
      row3Column2TextProvider: .init(format: waterLevel.type.rawValue.capitalized)
    )
  }
}
