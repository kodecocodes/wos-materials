import SwiftUI
import HealthKit

enum Glass {
  case small, large
}

struct LogWaterButton: View {
  let title: String
  let size: Glass
  let onTap: (HKQuantity) -> Void

  var body: some View {
    Button(title, action: tapped)
  }

  init(size: Glass, onTap: @escaping (HKQuantity) -> Void) {
    switch (Locale.current.measurementSystem, size) {
    case (.metric, .small): title = "250ml"
    case (.metric, .large): title = "500ml"
    case (_, .small): title = "8oz"
    case (_, .large): title = "16oz"
    }

    self.onTap = onTap
    self.size = size
  }

  private func tapped() {
  }
}

struct LogWaterButton_Previews: PreviewProvider {
  static var previews: some View {
    LogWaterButton(size: .small) { _ in }
  }
}
