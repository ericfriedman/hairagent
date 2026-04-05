import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let emoji: String
    let x: CGFloat
    let speed: Double
    let rotation: Double
    let size: CGFloat
    let delay: Double
}

struct ConfettiView: View {
    @State private var animate = false

    private let pieces: [ConfettiPiece] = {
        let emojis = [
            "\u{1F389}", "\u{1F38A}", "\u{2B50}", "\u{1F496}",
            "\u{2728}", "\u{1F497}", "\u{1F31F}", "\u{1F4AB}",
            "\u{1F380}", "\u{2764}\u{FE0F}", "\u{1F49C}", "\u{1F49B}"
        ]
        var result: [ConfettiPiece] = []
        for i in 0..<40 {
            result.append(ConfettiPiece(
                emoji: emojis[i % emojis.count],
                x: CGFloat.random(in: 0.0...1.0),
                speed: Double.random(in: 0.6...1.4),
                rotation: Double.random(in: -30...30),
                size: CGFloat.random(in: 16...32),
                delay: Double.random(in: 0...0.8)
            ))
        }
        return result
    }()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    Text(piece.emoji)
                        .font(.system(size: piece.size))
                        .rotationEffect(.degrees(animate ? piece.rotation + 360 : piece.rotation))
                        .position(
                            x: piece.x * geo.size.width,
                            y: animate
                                ? geo.size.height + 50
                                : -50
                        )
                        .animation(
                            .easeIn(duration: 2.5 * piece.speed)
                            .delay(piece.delay),
                            value: animate
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}
