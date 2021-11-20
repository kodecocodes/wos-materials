import Foundation

// swiftlint:disable force_unwrapping

@MainActor
class Season: NSObject, ObservableObject {
  static let shared = Season()
  @Published var upcomingMatches: [Match] = []
  @Published var nextMatch: Match?
  
  var matches: [Match] = [] {
    didSet {
      upcomingMatches = matches.filter { $0.date > Date.now }
      nextMatch = upcomingMatches.first
    }
  }

  let ourTeam: Team

  private let teams = [
    "Angels", "Big Red", "Claws", "Jellies", "Jumbos", "Sabers",
    "Sharks", "Shells", "Stallions", "Stars", "Turtles", "Whales"
  ]
    .shuffled()

  private let locations = [
    "Wembley Natatorium", "Hathaway Country Club", "Rosenbury Farms",
    "Texas Pool", "Olympic Square"
  ]
    .shuffled()
  
  private override init() {
    ourTeam = Team(name: "Octopi")

    let numLocations = locations.count

    // Make it look like we're halfway through the season.
    var date = Calendar.current.date(
      byAdding: .weekOfYear,
      value: teams.count / -2,
      to: Date.now)!

    super.init()
    
    matches = teams
      .enumerated()
      .map { ($0, Team(name: $1)) }
      .shuffled()
      .map { index, team in
        date = Calendar.current.date(
          bySettingHour: Int.random(in: 18 ... 20),
          minute: Bool.random() ? 0 : 30,
          second: 0,
          of: date)!

        date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date)!

        let location = locations[index % numLocations]
        return Match(on: date, against: team, at: location, ourTeam: ourTeam)
      }
    
    DispatchQueue.main.async {
      self.upcomingMatches = self.matches.filter { $0.date > Date.now }
      self.nextMatch = self.upcomingMatches.first
    }
  }

  func pastMatches() -> [Match] {
    let now = Date.now
    return matches.filter { $0.date < now }
  }

  func record() -> String {
    let record = pastMatches()
      .reduce((won: 0, lost: 0, tied: 0)) { prev, match in
        var result = prev

        guard let winner = match.winner else {
          result.tied += 1
          return result
        }

        if winner == ourTeam {
          result.won += 1
        } else {
          result.lost += 1
        }

        return result
      }

    return "\(record.won)-\(record.lost)-\(record.tied)"
  }
  
  func makeSnapshotShowSchedule() {
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    let opponent = Team(name: teams.randomElement()!)
    let location = locations.randomElement()!
    let match = Match(on: tomorrow, against: opponent, at: location, ourTeam: ourTeam)
    
    var matches = self.matches
    matches.append(match)
    matches.sort { $0.date < $1.date }

    if let index = matches.lastIndex(where: {
      let date = $0.date
      return date < Date.now && (Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date))
    }) {
      matches.remove(at: index)
    }

    self.matches = matches
  }
}
