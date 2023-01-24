import SwiftUI

// swiftlint:disable implicitly_unwrapped_optional
class BrushingModel: NSObject, ObservableObject {
  @Published var roundsLeft = 0
  @Published var endOfRound: Date?
  @Published var endOfBrushing: Date?
  
  private var timer: Timer!
  private var session: WKExtendedRuntimeSession!
  private var started: Date!
  
  func startBrushing() {
    session = WKExtendedRuntimeSession()
    session.delegate = self
    session.start()
  }
  
  func cancelBrushing() {
    stopBrushing()
    session.invalidate()
  }
  
  private func stopBrushing() {
    timer.invalidate()
    timer = nil
    
    endOfRound = nil
    endOfBrushing = nil
    roundsLeft = 0
  }
}

extension BrushingModel: WKExtendedRuntimeSessionDelegate {
  func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
    let secondsPerRound = 30.0
    
    started = Date.now
    endOfRound = started.addingTimeInterval(secondsPerRound)
    endOfBrushing = started.addingTimeInterval(secondsPerRound * 4)
    
    roundsLeft = 3
    
    let device = WKInterfaceDevice.current()
    device.play(.start)
    
    let date = Date.now.addingTimeInterval(secondsPerRound)
    
    timer = Timer(fire: date, interval: secondsPerRound, repeats: true) { _ in
      self.roundsLeft -= 1
      
      guard self.roundsLeft < 0 else {
        self.endOfRound = Date.now.addingTimeInterval(secondsPerRound)
        device.play(.success)
        return
      }
      
      self.stopBrushing()
      
      device.play(.success)
      device.play(.success)
      
      Task {
        try? await HealthStore.shared.logBrushing(startDate: self.started)

        self.session.invalidate()
      }
    }
    
    RunLoop.main.add(timer, forMode: .common)
  }
  
  func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
  }
  
  func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
    NotificationCenter.default.post(name: .dismissSheets, object: nil)
  }
}
