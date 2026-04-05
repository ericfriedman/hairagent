import SwiftUI

// MARK: - Squiggly border shape

struct SquigglyRectangle: Shape {
    var waveHeight: CGFloat = 6
    var wavesPerEdge: CGFloat = 15
    var inset: CGFloat = 12

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = rect.insetBy(dx: inset, dy: inset)
        let segments = 200

        // Top edge (left to right)
        for i in 0...segments {
            let t = CGFloat(i) / CGFloat(segments)
            let x = r.minX + t * r.width
            let y = r.minY + sin(t * .pi * 2 * wavesPerEdge) * waveHeight
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        // Right edge (top to bottom)
        for i in 1...segments {
            let t = CGFloat(i) / CGFloat(segments)
            let x = r.maxX - sin(t * .pi * 2 * wavesPerEdge) * waveHeight
            let y = r.minY + t * r.height
            path.addLine(to: CGPoint(x: x, y: y))
        }

        // Bottom edge (right to left)
        for i in 1...segments {
            let t = CGFloat(i) / CGFloat(segments)
            let x = r.maxX - t * r.width
            let y = r.maxY - sin(t * .pi * 2 * wavesPerEdge) * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }

        // Left edge (bottom to top)
        for i in 1...segments {
            let t = CGFloat(i) / CGFloat(segments)
            let x = r.minX + sin(t * .pi * 2 * wavesPerEdge) * waveHeight
            let y = r.maxY - t * r.height
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - Decorative background

struct DecorativeBackground: View {
    let style: Style

    enum Style {
        case welcome
        case nameEntry
        case quizColor
        case quizTexture
        case quizGoals
        case results
        case tipDetail
        case mySchedule
        case calendar
        case badges

        var gradientColors: [Color] {
            switch self {
            case .welcome:
                [AppTheme.pastelPink.opacity(0.55), AppTheme.pastelBlue.opacity(0.45), AppTheme.pastelYellow.opacity(0.4)]
            case .nameEntry:
                [AppTheme.pastelBlue.opacity(0.45), AppTheme.pastelPink.opacity(0.4)]
            case .quizColor:
                [AppTheme.pastelPink.opacity(0.5), AppTheme.pastelCoral.opacity(0.35)]
            case .quizTexture:
                [AppTheme.pastelBlue.opacity(0.5), AppTheme.pastelPink.opacity(0.35)]
            case .quizGoals:
                [AppTheme.pastelYellow.opacity(0.5), AppTheme.pastelCoral.opacity(0.35)]
            case .results:
                [AppTheme.pastelCoral.opacity(0.45), AppTheme.pastelYellow.opacity(0.4), AppTheme.pastelPink.opacity(0.35)]
            case .tipDetail:
                [AppTheme.pastelPink.opacity(0.35), AppTheme.pastelBlue.opacity(0.25)]
            case .mySchedule:
                [AppTheme.pastelBlue.opacity(0.45), AppTheme.pastelPink.opacity(0.35), AppTheme.pastelYellow.opacity(0.3)]
            case .calendar:
                [AppTheme.pastelPink.opacity(0.45), AppTheme.pastelYellow.opacity(0.4), AppTheme.pastelBlue.opacity(0.35)]
            case .badges:
                [AppTheme.pastelYellow.opacity(0.45), AppTheme.pastelPink.opacity(0.4), AppTheme.pastelBlue.opacity(0.35)]
            }
        }

        var hasExtraDecorations: Bool {
            self == .welcome || self == .results || self == .mySchedule || self == .calendar || self == .badges
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: style.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                // Soft background blobs
                blobs(w: w, h: h)

                // Core decorations
                hearts(w: w, h: h)
                sparkles(w: w, h: h)
                stars(w: w, h: h)
                bows(w: w, h: h)
                hairIcons(w: w, h: h)

                // Extra flair for welcome + results
                if style.hasExtraDecorations {
                    extraFlair(w: w, h: h)
                }
            }
            .allowsHitTesting(false)

            // Hot pink squiggly border
            SquigglyRectangle(waveHeight: 7, wavesPerEdge: 15, inset: 14)
                .stroke(AppTheme.hotPink, lineWidth: 3.5)
        }
        .ignoresSafeArea()
    }

    // MARK: - Soft color blobs

    @ViewBuilder
    private func blobs(w: CGFloat, h: CGFloat) -> some View {
        Circle()
            .fill(AppTheme.pastelPink.opacity(0.25))
            .frame(width: 260, height: 260)
            .position(x: w * 0.85, y: h * 0.12)

        Circle()
            .fill(AppTheme.pastelBlue.opacity(0.2))
            .frame(width: 220, height: 220)
            .position(x: w * 0.1, y: h * 0.75)

        Circle()
            .fill(AppTheme.pastelYellow.opacity(0.18))
            .frame(width: 180, height: 180)
            .position(x: w * 0.6, y: h * 0.92)
    }

    // MARK: - Hearts (bigger & bolder)

    @ViewBuilder
    private func hearts(w: CGFloat, h: CGFloat) -> some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 55))
            .foregroundStyle(AppTheme.pastelPink.opacity(0.55))
            .position(x: w * 0.08, y: h * 0.12)

        Image(systemName: "heart.fill")
            .font(.system(size: 40))
            .foregroundStyle(AppTheme.hotPink.opacity(0.35))
            .position(x: w * 0.93, y: h * 0.09)

        Image(systemName: "heart.fill")
            .font(.system(size: 48))
            .foregroundStyle(AppTheme.pastelPink.opacity(0.5))
            .rotationEffect(.degrees(-15))
            .position(x: w * 0.9, y: h * 0.78)

        Image(systemName: "heart.fill")
            .font(.system(size: 35))
            .foregroundStyle(AppTheme.pastelCoral.opacity(0.45))
            .rotationEffect(.degrees(10))
            .position(x: w * 0.15, y: h * 0.52)
    }

    // MARK: - Sparkles (bigger & bolder)

    @ViewBuilder
    private func sparkles(w: CGFloat, h: CGFloat) -> some View {
        Image(systemName: "sparkle")
            .font(.system(size: 30))
            .foregroundStyle(AppTheme.pastelYellow.opacity(0.7))
            .position(x: w * 0.2, y: h * 0.25)

        Image(systemName: "sparkle")
            .font(.system(size: 26))
            .foregroundStyle(AppTheme.pastelBlue.opacity(0.65))
            .position(x: w * 0.78, y: h * 0.42)

        Image(systemName: "sparkle")
            .font(.system(size: 28))
            .foregroundStyle(AppTheme.pastelYellow.opacity(0.6))
            .position(x: w * 0.62, y: h * 0.88)
    }

    // MARK: - Stars (bigger & bolder)

    @ViewBuilder
    private func stars(w: CGFloat, h: CGFloat) -> some View {
        Image(systemName: "star.fill")
            .font(.system(size: 30))
            .foregroundStyle(AppTheme.pastelYellow.opacity(0.6))
            .position(x: w * 0.1, y: h * 0.65)

        Image(systemName: "star.fill")
            .font(.system(size: 24))
            .foregroundStyle(AppTheme.pastelCoral.opacity(0.55))
            .position(x: w * 0.85, y: h * 0.55)
    }

    // MARK: - Bows (bigger & bolder)

    @ViewBuilder
    private func bows(w: CGFloat, h: CGFloat) -> some View {
        BowView(color: AppTheme.hotPink.opacity(0.4), size: 75)
            .position(x: w * 0.88, y: h * 0.22)

        BowView(color: AppTheme.pastelCoral.opacity(0.5), size: 58)
            .position(x: w * 0.1, y: h * 0.88)
    }

    // MARK: - Hair care icons (bigger & bolder)

    @ViewBuilder
    private func hairIcons(w: CGFloat, h: CGFloat) -> some View {
        Image(systemName: "scissors")
            .font(.system(size: 32))
            .foregroundStyle(AppTheme.pastelCoral.opacity(0.5))
            .rotationEffect(.degrees(-30))
            .position(x: w * 0.06, y: h * 0.4)
    }

    // MARK: - Extra decorations for welcome & results

    @ViewBuilder
    private func extraFlair(w: CGFloat, h: CGFloat) -> some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 35))
            .foregroundStyle(AppTheme.hotPink.opacity(0.3))
            .position(x: w * 0.5, y: h * 0.04)

        Image(systemName: "sparkles")
            .font(.system(size: 35))
            .foregroundStyle(AppTheme.pastelPink.opacity(0.55))
            .position(x: w * 0.35, y: h * 0.92)

        BowView(color: AppTheme.pastelBlue.opacity(0.45), size: 50)
            .position(x: w * 0.55, y: h * 0.95)

        Image(systemName: "heart.fill")
            .font(.system(size: 28))
            .foregroundStyle(AppTheme.pastelYellow.opacity(0.5))
            .rotationEffect(.degrees(20))
            .position(x: w * 0.42, y: h * 0.15)

        Image(systemName: "star.fill")
            .font(.system(size: 26))
            .foregroundStyle(AppTheme.hotPink.opacity(0.3))
            .position(x: w * 0.7, y: h * 0.07)
    }
}
