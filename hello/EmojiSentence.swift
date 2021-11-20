import SwiftUI

@MainActor
class EmojiSentence: ObservableObject {
    @Published var text = ""
    @Published var emoji = ""

    private let sentences = [
        (text: "Not my cup of tea", emoji: "🙅‍♀️ ☕️"),
        (text: "Talk to the hand", emoji: "🎙 ✋"),
        (text: "Not the brightest bulb", emoji: "🚫 😎 💡"),
        (text: "When pigs fly", emoji: "⏰ 🐷 ✈️"),
        (text: "Boy who cried wolf", emoji: "🚶😭🐺")
    ]
    private var index = 0

    init() {
        update()
    }

    func next() {
        index += 1
        if index == sentences.count {
            index = 0
        }

        update()
    }

    private func update() {
        text = sentences[index].text
        emoji = sentences[index].emoji
    }
}
