import SwiftUI

// MARK: - Before hair strands (per texture)

struct BeforeHairStrands: Shape {
    let texture: HairTexture

    func path(in rect: CGRect) -> Path {
        switch texture {
        case .frizzy: return frizzyPath(in: rect)
        case .oily: return oilyPath(in: rect)
        case .dry: return dryPath(in: rect)
        case .damaged: return damagedPath(in: rect)
        case .other: return frizzyPath(in: rect)
        }
    }

    private func frizzyPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            let segments = 6
            for s in 1...segments {
                let y = rect.minY + 4 + (rect.height - 8) * CGFloat(s) / CGFloat(segments)
                let offset: CGFloat = ((s % 2 == 0) ? 1 : -1) * (6 + CGFloat(i % 3) * 2)
                path.addLine(to: CGPoint(x: x + offset, y: y))
            }
        }
        return path
    }

    private func oilyPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        let centerX = rect.midX
        for i in 0..<strandCount {
            let startX = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            let endX = centerX + CGFloat(i - 2) * 4
            path.move(to: CGPoint(x: startX, y: rect.minY + 4))
            path.addQuadCurve(
                to: CGPoint(x: endX, y: rect.maxY - 4),
                control: CGPoint(x: (startX + endX) / 2, y: rect.height * 0.7)
            )
        }
        return path
    }

    private func dryPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            let segments = 8
            for s in 1...segments {
                let y = rect.minY + 4 + (rect.height - 8) * CGFloat(s) / CGFloat(segments)
                let jitter = CGFloat((s * (i + 1) * 7) % 11) / 11.0 * 5.0 - 2.5
                path.addLine(to: CGPoint(x: x + jitter, y: y))
            }
        }
        return path
    }

    private func damagedPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            let splitY = rect.maxY - rect.height * 0.25
            path.addLine(to: CGPoint(x: x, y: splitY))
            path.addLine(to: CGPoint(x: x - 5, y: rect.maxY - 4))
            path.move(to: CGPoint(x: x, y: splitY))
            path.addLine(to: CGPoint(x: x + 5, y: rect.maxY - 4))
        }
        return path
    }
}

// MARK: - After hair strands (per solution type)

struct AfterHairStrands: Shape {
    let solutionType: SolutionType

    func path(in rect: CGRect) -> Path {
        switch solutionType {
        case .moisturizing: return smoothPath(in: rect)
        case .protein: return strongPath(in: rect)
        case .clarifying: return cleanPath(in: rect)
        case .smoothing: return sleekPath(in: rect)
        case .scalp: return healthyPath(in: rect)
        case .strengthening: return bouncyPath(in: rect)
        }
    }

    private func smoothPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + 3, y: rect.maxY - 4),
                control1: CGPoint(x: x + 8, y: rect.height * 0.35),
                control2: CGPoint(x: x - 8, y: rect.height * 0.65)
            )
        }
        return path
    }

    private func strongPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 6
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + 2, y: rect.maxY - 4),
                control1: CGPoint(x: x + 5, y: rect.height * 0.4),
                control2: CGPoint(x: x - 3, y: rect.height * 0.7)
            )
        }
        return path
    }

    private func cleanPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x, y: rect.maxY - 4),
                control1: CGPoint(x: x + 3, y: rect.height * 0.3),
                control2: CGPoint(x: x - 2, y: rect.height * 0.7)
            )
        }
        return path
    }

    private func sleekPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + 1, y: rect.maxY - 4),
                control1: CGPoint(x: x + 2, y: rect.height * 0.4),
                control2: CGPoint(x: x, y: rect.height * 0.6)
            )
        }
        return path
    }

    private func healthyPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 5
        for i in 0..<strandCount {
            let x = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            path.move(to: CGPoint(x: x, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: x + CGFloat(i - 2) * 2, y: rect.maxY - 4),
                control1: CGPoint(x: x, y: rect.height * 0.3),
                control2: CGPoint(x: x + CGFloat(i - 2) * 3, y: rect.height * 0.6)
            )
        }
        return path
    }

    private func bouncyPath(in rect: CGRect) -> Path {
        var path = Path()
        let strandCount = 6
        for i in 0..<strandCount {
            let startX = rect.width * CGFloat(i + 1) / CGFloat(strandCount + 1)
            let spread = CGFloat(i - strandCount / 2) * 3
            path.move(to: CGPoint(x: startX, y: rect.minY + 4))
            path.addCurve(
                to: CGPoint(x: startX + spread, y: rect.maxY - 4),
                control1: CGPoint(x: startX + 6, y: rect.height * 0.3),
                control2: CGPoint(x: startX + spread - 4, y: rect.height * 0.65)
            )
        }
        return path
    }
}

// MARK: - Combined before/after view for cards

struct BeforeAfterView: View {
    let hairColor: Color
    let texture: HairTexture
    let solutionType: SolutionType
    let size: CGSize

    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 4) {
                BeforeHairStrands(texture: texture)
                    .stroke(hairColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: size.width / 2 - 8, height: size.height - 20)

                Text("Before")
                    .font(AppTheme.bodyFont(size: 11))
                    .foregroundStyle(.gray)
            }

            VStack(spacing: 4) {
                ZStack {
                    AfterHairStrands(solutionType: solutionType)
                        .stroke(hairColor.opacity(0.3), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .blur(radius: 4)

                    AfterHairStrands(solutionType: solutionType)
                        .stroke(hairColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                }
                .frame(width: size.width / 2 - 8, height: size.height - 20)

                Text("After")
                    .font(AppTheme.bodyFont(size: 11))
                    .foregroundStyle(.gray)
            }
        }
    }
}
