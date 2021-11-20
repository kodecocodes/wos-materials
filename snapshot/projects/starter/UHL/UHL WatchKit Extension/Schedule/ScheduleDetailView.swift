import SwiftUI

struct ScheduleDetailView: View {
  let match: Match

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
  }
}

struct ScheduleDetailView_Previews: PreviewProvider {
  static var previews: some View {
    // swiftlint:disable:next force_unwrapping
    ScheduleDetailView(match: Season.shared.nextMatch!)
  }
}
