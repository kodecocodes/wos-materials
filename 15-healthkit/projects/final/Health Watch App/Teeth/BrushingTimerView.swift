import SwiftUI

struct BrushingTimerView: View {
  @ObservedObject private var model = BrushingModel()
  
  var body: some View {
    VStack {
      if let endOfBrushing = model.endOfBrushing,
         let endOfRound = model.endOfRound,
         model.roundsLeft > 0 {
        Text("Rounds Left: \(model.roundsLeft)")
        Text("Total time left: \(endOfBrushing, style: .timer)")
        Text("This round: \(endOfRound, style: .timer)")
        
        Spacer()
        
        Button("Cancel") { model.cancelBrushing() }
      } else {
        EmptyView()
      }
    }
    .task { model.startBrushing() }
  }
}

struct BrushingTimerView_Previews: PreviewProvider {
  static var previews: some View {
    BrushingTimerView()
  }
}
