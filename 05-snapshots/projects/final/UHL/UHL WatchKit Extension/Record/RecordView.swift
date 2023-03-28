import SwiftUI

struct RecordView: View {
  @EnvironmentObject private var season: Season
  let snapshotHandler: (() -> Void)?

  var body: some View {
    List(season.pastMatches().reversed()) {
      RecordRow(match: $0)
    }
    .listStyle(.carousel)
    .navigationBarTitle("Scores")
    .task {
      snapshotHandler?()
    }
  }
}

struct RecordView_Previews: PreviewProvider {
  static var previews: some View {
    RecordView(snapshotHandler: nil)
  }
}
