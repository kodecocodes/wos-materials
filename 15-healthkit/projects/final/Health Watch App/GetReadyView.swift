import SwiftUI

struct GetReadyView: View {
  @State private var trim = 1.0
  @State private var text = "Ready"
  @State private var stage: Int

  private let denominator: Double
  private let color: Color
  private let onComplete: () -> Void

  init(color: Color = .green, stages: Int = 4, onComplete: @escaping () -> Void) {
    self.color = color
    self.onComplete = onComplete
    _stage = State(initialValue: stages)
    denominator = Double(stages) - 1.0
  }

  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    ZStack {
      Circle()
        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .foregroundColor(color.opacity(0.5))

      Circle()
        .trim(from: 0, to: trim)
        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .rotationEffect(.degrees(-90))
        .foregroundColor(color)
        .animation(.linear, value: trim)

      Text(text)
        .font(.title)
    }
    .background(Color.black)
    .onReceive(timer) { _ in tick() }
    .padding()
  }

  private func tick() {
    stage -= 1

    guard stage > 0 else {
      timer.upstream.connect().cancel()
      WKInterfaceDevice.current().play(.success)
      onComplete()
      return
    }

    WKInterfaceDevice.current().play(.start)

    if stage == 1 {
      trim = 0.005
    } else {
      trim = Double(stage - 1) / denominator
    }

    text = "\(stage)"
  }
}

struct CircularProgressView_Previews: PreviewProvider {
  static var previews: some View {
    GetReadyView { }
  }
}
