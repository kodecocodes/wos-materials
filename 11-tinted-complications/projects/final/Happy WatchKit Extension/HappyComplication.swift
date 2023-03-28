import SwiftUI
import ClockKit

struct HappyComplication: View {
  @Environment(\.complicationRenderingMode) var renderingMode
  
  var body: some View {
    ZStack {
      if renderingMode == .fullColor {
        Image("Full")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .complicationForeground()
      } else {
        Circle()
          .fill(LinearGradient(
            gradient: Gradient(
              colors: [.red.opacity(0.3), .blue.opacity(1.0)]
            ),
            startPoint: .top,
            endPoint: .bottom))

        Image("eyesAndMouth")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .complicationForeground()
      }
    }
  }
}

struct HappyComplication_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ForEach(CLKComplicationTemplate.PreviewFaceColor.allColors) {
        CLKComplicationTemplateGraphicExtraLargeCircularView(
          HappyComplication()
        )
          .previewContext(faceColor: $0)
      }
    }
  }
}
