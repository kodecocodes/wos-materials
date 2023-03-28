import ClockKit

protocol ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate
  func templateForSample() -> CLKComplicationTemplate
  func textProvider(for temperature: Double, unitStyle: Formatter.UnitStyle) -> CLKSimpleTextProvider
  func fullColorImageProvider() -> CLKFullColorImageProvider
  func plainImageProvider() -> CLKImageProvider
}

extension ComplicationTemplateFactory {
  func templateForSample() -> CLKComplicationTemplate {
    return template(for: 0)
  }

  func textProvider(
    for temperature: Double,
    unitStyle: Formatter.UnitStyle = .medium
  ) -> CLKSimpleTextProvider {
    let fahrenheit = Measurement(
      value: temperature,
      unit: UnitTemperature.fahrenheit
    )

    formatter.unitStyle = unitStyle
    
    return .init(text: formatter.string(from: fahrenheit))
  }

  func fullColorImageProvider() -> CLKFullColorImageProvider {
    // swiftlint:disable:next force_unwrapping
    let image = UIImage(systemName: "thermometer")!
    return .init(fullColorImage: image)
  }

  func plainImageProvider() -> CLKImageProvider {
    // swiftlint:disable:next force_unwrapping
    let image = UIImage(systemName: "thermometer")!
    return .init(onePieceImage: image)
  }
}

let formatter: MeasurementFormatter = {
  let fmt = MeasurementFormatter()
  fmt.unitStyle = .medium

  return fmt
}()
