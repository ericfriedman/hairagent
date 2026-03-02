import SwiftUI

struct BowView: View {
    let color: Color
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            // Left loop
            Ellipse()
                .fill(color)
                .frame(width: size * 0.48, height: size * 0.38)
                .rotationEffect(.degrees(-30))
                .offset(x: -size * 0.18, y: -size * 0.06)

            // Right loop
            Ellipse()
                .fill(color)
                .frame(width: size * 0.48, height: size * 0.38)
                .rotationEffect(.degrees(30))
                .offset(x: size * 0.18, y: -size * 0.06)

            // Center knot
            Ellipse()
                .fill(color)
                .frame(width: size * 0.16, height: size * 0.2)

            // Left ribbon tail
            Capsule()
                .fill(color)
                .frame(width: size * 0.09, height: size * 0.28)
                .rotationEffect(.degrees(20))
                .offset(x: -size * 0.06, y: size * 0.2)

            // Right ribbon tail
            Capsule()
                .fill(color)
                .frame(width: size * 0.09, height: size * 0.28)
                .rotationEffect(.degrees(-20))
                .offset(x: size * 0.06, y: size * 0.2)
        }
        .frame(width: size, height: size * 0.75)
    }
}
