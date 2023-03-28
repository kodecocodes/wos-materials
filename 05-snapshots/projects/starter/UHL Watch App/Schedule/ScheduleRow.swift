import SwiftUI

struct ScheduleRow: View {
  let match: Match

  var body: some View {
    HStack {
      Image(match.opponent.logoName)
        .resizable()
        .frame(maxWidth: 50)
        .scaledToFit()

      VStack(alignment: .leading) {
        Text(match.opponent.name)
          .font(.headline)
        Divider()
        Text(match.date.formatted(.dateTime.year().month().day()))
          .font(.subheadline)
        Text("\(match.date, style: .time)")
          .font(.subheadline)
      }
    }
  }
}

struct ScheduleRow_Previews: PreviewProvider {
  static var previews: some View {
    // swiftlint:disable:next force_unwrapping
    ScheduleRow(match: Season.shared.nextMatch!)
  }
}
