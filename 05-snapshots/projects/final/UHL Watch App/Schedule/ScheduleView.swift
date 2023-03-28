import SwiftUI

struct ScheduleView: View {
  @EnvironmentObject private var season: Season
  let snapshotHandler: (() -> Void)?

  var body: some View {
    List {
      ForEach(season.upcomingMatches) { match in
        NavigationLink(value: ContentView.Destination.matchDetail(match: match)) {
          ScheduleRow(match: match)
        }
        .swipeActions {
          swipeActions(match: match)
        }
      }
    }
    .listStyle(.carousel)
    .navigationBarTitle("Upcoming")
    .task {
      snapshotHandler?()
    }
  }

  @ViewBuilder
  private func swipeActions(match: Match) -> some View {
    Button(role: .destructive) {
      let index = season.matches.firstIndex(of: match)!
      season.matches.remove(at: index)
    } label: {
      Label("Delete", systemImage: "trash")
    }

    Button {
      season.makeSnapshotShowSchedule()
    } label: {
      Label("Add", systemImage: "plus")
    }
  }
}

struct ScheduleView_Previews: PreviewProvider {
  static var previews: some View {
    ScheduleView(snapshotHandler: nil)
  }
}
