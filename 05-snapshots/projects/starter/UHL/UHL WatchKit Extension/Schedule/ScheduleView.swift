import SwiftUI

struct ScheduleView: View {
  @EnvironmentObject private var season: Season
  @Binding var selectedMatchId: Match.ID?

  var body: some View {
    List {
      ForEach(season.upcomingMatches) { match in
        NavigationLink(
          destination: ScheduleDetailView(
            match: match
          ),
          tag: match.id,
          selection: $selectedMatchId
        ) {
          ScheduleRow(match: match)
        }
        .swipeActions {
          swipeActions(match: match)
        }
      }
    }
    .listStyle(.carousel)
    .navigationBarTitle("Upcoming")
  }

  @ViewBuilder
  private func swipeActions(match: Match) -> some View {
    Button(role: .destructive) {
      // swiftlint:disable:next force_unwrapping
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
    ScheduleView(selectedMatchId: .constant(nil))
  }
}
