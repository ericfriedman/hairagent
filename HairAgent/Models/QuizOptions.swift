import Foundation

enum HairTexture: String, CaseIterable, Codable, Identifiable {
    case frizzy, oily, dry, damaged
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .other: return "Other"
        default: return rawValue.capitalized
        }
    }
}

enum HairGoal: String, CaseIterable, Codable, Identifiable {
    case addShine
    case lessFrizz
    case growLonger
    case stayHealthy
    case repairDamage
    case moreVolume
    case lessOil
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .addShine: return "Add Shine"
        case .lessFrizz: return "Less Frizz"
        case .growLonger: return "Grow Longer"
        case .stayHealthy: return "Stay Healthy"
        case .repairDamage: return "Repair Damage"
        case .moreVolume: return "More Volume"
        case .lessOil: return "Less Oil"
        case .other: return "Other"
        }
    }
}

enum SolutionType: String, CaseIterable, Codable, Identifiable {
    case moisturizing
    case protein
    case clarifying
    case smoothing
    case scalp
    case strengthening

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}
