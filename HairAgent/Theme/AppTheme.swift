import SwiftUI

enum AppTheme {
    // Brand colors - pastel palette
    static let pastelPink = Color(red: 1.0, green: 0.71, blue: 0.76)
    static let pastelBlue = Color(red: 0.68, green: 0.85, blue: 0.96)
    static let pastelYellow = Color(red: 1.0, green: 0.94, blue: 0.70)
    static let pastelCoral = Color(red: 1.0, green: 0.60, blue: 0.56)
    static let hotPink = Color(red: 1.0, green: 0.0, blue: 0.5)
    static let background = Color.white
    static let textPrimary = Color.black

    // Accent colors for quiz options
    static let quizAccents: [Color] = [pastelPink, pastelBlue, pastelYellow, pastelCoral]

    // Typography
    static func headingFont(size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func bodyFont(size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
}
