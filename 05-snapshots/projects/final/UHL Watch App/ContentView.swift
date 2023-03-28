import SwiftUI
import Combine

struct ContentView: View {
  @EnvironmentObject private var season: Season
  @State private var snapshotHandler: (() -> Void)?
  @State private var path: [Destination] = []

  private let pushViewForSnapshotPublisher = NotificationCenter
    .default
    .publisher(for: .pushViewForSnapshot)

  public enum Destination: Hashable {
    case record
    case schedule
    case matchDetail(match: Match)

    public func hash(into hasher: inout Hasher) {
      switch self {
      case .record:
        hasher.combine("record")
      case .schedule:
        hasher.combine("schedule")
      case .matchDetail(let match):
        hasher.combine("matchDetail")
        hasher.combine(match.id)
      }
    }
  }

  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        Label(season.ourTeam.name, image: season.ourTeam.logoName)

        if let match = season.nextMatch {
          NavigationLink(value: Destination.schedule) {
            VStack(alignment: .leading) {
              HStack {
                Text("Next: ")
                  .font(.headline)
                Text(match.opponent.name)
                  .font(.body)
              }

              Text(match.date.formatted(.dateTime
                .hour()
                .minute()
                .year(.twoDigits)
                .month(.defaultDigits)
                .day(.defaultDigits)))
              .font(.subheadline)
            }
          }
        }

        NavigationLink(value: Destination.record) {
          HStack {
            Text("Record: ")
              .font(.headline)
            Text(season.record())
              .font(.body)
          }
        }
        .onReceive(pushViewForSnapshotPublisher) {
          pushViewForSnapshot($0)
        }
      }
      .navigationDestination(for: Destination.self) { destination in
        switch destination {
        case .schedule:
          ScheduleView(snapshotHandler: snapshotHandler)
        case .record:
          RecordView(snapshotHandler: snapshotHandler)
        case .matchDetail(let match):
          ScheduleDetailView(match: match, snapshotHandler: snapshotHandler)
        }
      }
    }
  }

  private func pushViewForSnapshot(_ notification: Notification) {
    guard let info = try? SnapshotUserInfo.from(notification: notification) else {
      return
    }

    snapshotHandler = info.handler

    path.append(info.destination)

    if let matchId = info.matchId, let match = season.match(with: matchId) {
      path.append(.matchDetail(match: match))
    }
  }

  private func handleSnapshot() {
    snapshotHandler?()
    snapshotHandler = nil
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Season.shared)
  }
}
