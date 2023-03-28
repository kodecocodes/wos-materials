import Foundation

struct Match: Equatable, Identifiable {
  let id = UUID()
  let home: Team
  let away: Team
  let date: Date
  let location: String
  let result: MatchResult?

  var opponent: Team {
    return home == Season.shared.ourTeam ? away : home
  }

  var winner: Team? {
    guard let result = result else {
      return nil
    }

    if result.homeTeamScore > result.awayTeamScore {
      return home
    } else if result.homeTeamScore < result.awayTeamScore {
      return away
    } else {
      return nil
    }
  }

  init(on date: Date, against team: Team, at location: String, ourTeam: Team) {
    if Bool.random() {
      home = ourTeam
      away = team
    } else {
      home = team
      away = ourTeam
    }

    if date < Date.now {
      result = MatchResult(
        homeTeamScore: Int.random(in: 0 ... 10),
        awayTeamScore: Int.random(in: 0 ... 10)
      )
    } else {
      result = nil
    }

    self.date = date
    self.location = location
  }

  func score(for team: Team) -> Int? {
    return team == home ? result?.homeTeamScore : result?.awayTeamScore
  }

  static func == (lhs: Match, rhs: Match) -> Bool {
    return lhs.date == rhs.date && lhs.home == rhs.home && lhs.away == rhs.away
  }
}
