import SwiftUI

enum BadgeType: String, CaseIterable, Identifiable {
    case moistureQueen
    case frizzFighter
    case shineStar
    case scalpGuru
    case strengthBoss
    case maskMaster
    case consistencyChamp
    case heatFreeHero
    case protectivePro

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .moistureQueen: return "Moisture Queen"
        case .frizzFighter: return "Frizz Fighter"
        case .shineStar: return "Shine Star"
        case .scalpGuru: return "Scalp Guru"
        case .strengthBoss: return "Strength Boss"
        case .maskMaster: return "Mask Master"
        case .consistencyChamp: return "Consistency Champ"
        case .heatFreeHero: return "Heat-Free Hero"
        case .protectivePro: return "Protective Pro"
        }
    }

    var icon: String {
        switch self {
        case .moistureQueen: return "💖"
        case .frizzFighter: return "⚡"
        case .shineStar: return "✨"
        case .scalpGuru: return "🌿"
        case .strengthBoss: return "💪"
        case .maskMaster: return "🧖"
        case .consistencyChamp: return "🏆"
        case .heatFreeHero: return "🔥"
        case .protectivePro: return "🛡️"
        }
    }

    var subtitle: String {
        switch self {
        case .moistureQueen: return "Completed mask week"
        case .frizzFighter: return "Beat the frizz"
        case .shineStar: return "3 shine weeks done"
        case .scalpGuru: return "5 scalp care days"
        case .strengthBoss: return "Protein week done"
        case .maskMaster: return "10 masks completed"
        case .consistencyChamp: return "4 weeks in a row"
        case .heatFreeHero: return "No heat for 2 weeks"
        case .protectivePro: return "Protected all month"
        }
    }

    var gradientColors: (Color, Color) {
        switch self {
        case .moistureQueen: return (Color(red: 1.0, green: 0.41, blue: 0.71), Color(red: 1.0, green: 0.08, blue: 0.58))
        case .frizzFighter: return (Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.25, green: 0.41, blue: 0.88))
        case .shineStar: return (Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0))
        case .scalpGuru: return (Color(red: 0.60, green: 0.98, blue: 0.60), Color(red: 0.20, green: 0.80, blue: 0.20))
        case .strengthBoss: return (Color(red: 0.87, green: 0.63, blue: 0.87), Color(red: 0.58, green: 0.44, blue: 0.86))
        case .maskMaster: return (Color(red: 1.0, green: 0.71, blue: 0.76), Color(red: 1.0, green: 0.41, blue: 0.71))
        case .consistencyChamp: return (Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.27, blue: 0.0))
        case .heatFreeHero: return (Color(red: 1.0, green: 0.60, blue: 0.56), Color(red: 1.0, green: 0.27, blue: 0.0))
        case .protectivePro: return (Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.20, green: 0.80, blue: 0.20))
        }
    }
}

struct EarnedBadge: Identifiable {
    let id = UUID()
    let type: BadgeType
    let earnedDate: Date
}
