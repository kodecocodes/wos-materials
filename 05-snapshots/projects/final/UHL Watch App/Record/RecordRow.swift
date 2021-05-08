import SwiftUI

struct RecordRow: View {
  @EnvironmentObject private var season: Season
  
  let match: Match

  var body: some View {
    VStack {
      Text("\(match.date, style: .date)")
        .font(.caption)
      Divider()

      HStack {
        Label(match.home.name, image: match.home.logoName)

        Spacer()

        // swiftlint:disable:next force_unwrapping
        Text("\(match.score(for: match.home)!)")
          .font(.title)
          .foregroundColor(scoreColor(for: match.home))
      }

      HStack {
        Label(match.away.name, image: match.away.logoName)

        Spacer()

        // swiftlint:disable:next force_unwrapping
        Text("\(match.score(for: match.away)!)")
          .font(.title)
          .foregroundColor(scoreColor(for: match.away))
      }
    }
  }

  private func scoreColor(for team: Team) -> Color {
    guard let winner = match.winner else {
      return .white
    }

    if winner == season.ourTeam && team == season.ourTeam {
      return .green
    } else if winner != season.ourTeam && team != season.ourTeam {
      return .red
    } else {
      return .white
    }
  }
}

struct RecordRow_Previews: PreviewProvider {
  static var previews: some View {
    // swiftlint:disable:next force_unwrapping
    RecordRow(match: Season.shared.pastMatches().first!)
  }
}
