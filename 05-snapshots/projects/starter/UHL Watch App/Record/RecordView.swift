import SwiftUI

struct RecordView: View {
  @EnvironmentObject private var season: Season

  var body: some View {
    List(season.pastMatches().reversed()) {
      RecordRow(match: $0)
    }
    .listStyle(.carousel)
    .navigationBarTitle("Scores")
  }
}

struct RecordView_Previews: PreviewProvider {
  static var previews: some View {
    RecordView()
  }
}
