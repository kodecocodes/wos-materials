import SwiftUI

struct RecordView: View {
  @EnvironmentObject private var season: Season
  private let snapshotHandler: (() -> Void)?
  private let matches: [Match]

  init(snapshotHandler: (() -> Void)?) {
    self.snapshotHandler = snapshotHandler
    matches = Season.shared.pastMatches().reversed()
  }

  var body: some View {
    if let snapshotHandler = snapshotHandler {
      snapshotView()
        .task {
          snapshotHandler()
        }
    } else {
      normalView()
    }
  }

  @ViewBuilder
  private func normalView() -> some View {
    List(season.pastMatches().reversed()) {
      RecordRow(match: $0)
    }
    .listStyle(.carousel)
    .navigationBarTitle("Scores")
    .task {
      snapshotHandler?()
    }
  }

  @ViewBuilder
  private func snapshotView() -> some View {
    if
      let match = matches.first,
      let result = match.result {
      if match.home == season.ourTeam {
        Text("\(result.homeTeamScore)-\(result.awayTeamScore) against \(match.away.name)")
      } else {
        Text("\(result.awayTeamScore)-\(result.homeTeamScore) against \(match.home.name)")
      }

      Spacer()
    } else {
      normalView()
    }
  }
}

struct RecordView_Previews: PreviewProvider {
  static var previews: some View {
    RecordView(snapshotHandler: nil)
  }
}
