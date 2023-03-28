import SwiftUI

struct ScheduleDetailView: View {
  let match: Match
  let snapshotHandler: (() -> Void)?

  var body: some View {
    VStack {
      Image(match.opponent.logoName)
      Text("vs \(match.opponent.name)")
        .font(.body)

      Divider()

      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "calendar")
          VStack(alignment: .leading) {
            Text("\(match.date, style: .date)")
            Text("\(match.date, style: .time)")
          }
          .font(.caption2)
        }
        .padding(.bottom)

        HStack {
          Image(systemName: "mappin")
          Text(match.location)
            .font(.caption2)
        }
      }
    }
    .task {
      snapshotHandler?()
    }
  }
}

struct ScheduleDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleDetailView(
      // swiftlint:disable:next force_unwrapping
      match: Season.shared.nextMatch!,
      snapshotHandler: nil
    )
  }
}
