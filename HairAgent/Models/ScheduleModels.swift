import Foundation

enum ScheduleActivityType: String, CaseIterable, Identifiable {
    case wash
    case mask
    case trim
    case scalpCare
    case heatFree
    case protectiveStyle

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .wash: return "Wash Day"
        case .mask: return "Mask Day"
        case .trim: return "Trim"
        case .scalpCare: return "Scalp Care"
        case .heatFree: return "Heat-Free"
        case .protectiveStyle: return "Protective Style"
        }
    }

    var icon: String {
        switch self {
        case .wash: return "drop.fill"
        case .mask: return "theatermask.and.paintbrush.fill"
        case .trim: return "scissors"
        case .scalpCare: return "hand.raised.fingers.spread.fill"
        case .heatFree: return "flame.fill"
        case .protectiveStyle: return "shield.fill"
        }
    }

    var emoji: String {
        switch self {
        case .wash: return "🧴"
        case .mask: return "🧖"
        case .trim: return "💇"
        case .scalpCare: return "💆"
        case .heatFree: return "🚫🔥"
        case .protectiveStyle: return "🛡️"
        }
    }
}

struct DaySchedule: Identifiable {
    let id = UUID()
    let day: Int
    var activities: [ScheduleActivityType]
}

enum ScheduleGenerator {
    static func daysInMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        let calendar = Calendar.current
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return 30
        }
        return range.count
    }

    static func firstWeekday(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let calendar = Calendar.current
        guard let date = calendar.date(from: components) else { return 1 }
        return calendar.component(.weekday, from: date)
    }

    static func generateMonth(
        year: Int,
        month: Int,
        texture: HairTexture,
        solutions: [HairSolution]
    ) -> [DaySchedule] {
        let totalDays = daysInMonth(year: year, month: month)
        var days = (1...totalDays).map { DaySchedule(day: $0, activities: []) }

        let washInterval: Int
        switch texture {
        case .oily: washInterval = 2
        case .frizzy: washInterval = 3
        case .dry: washInterval = 4
        case .damaged: washInterval = 3
        case .other: washInterval = 3
        }

        var day = 1
        while day <= totalDays {
            days[day - 1].activities.append(.wash)
            day += washInterval
        }

        let hasMaskSolution = solutions.contains { [.moisturizing, .protein, .smoothing].contains($0.solutionType) }
        if hasMaskSolution {
            let maskInterval: Int
            switch texture {
            case .dry, .frizzy: maskInterval = 4
            case .damaged: maskInterval = 5
            case .oily: maskInterval = 10
            case .other: maskInterval = 7
            }
            var maskDay = 4
            while maskDay <= totalDays {
                if !days[maskDay - 1].activities.contains(.wash) {
                    days[maskDay - 1].activities.append(.mask)
                }
                maskDay += maskInterval
            }
        }

        let hasScalpSolution = solutions.contains { $0.solutionType == .scalp }
        if hasScalpSolution {
            let scalpInterval: Int
            switch texture {
            case .oily: scalpInterval = 3
            case .dry: scalpInterval = 4
            default: scalpInterval = 4
            }
            var scalpDay = 5
            while scalpDay <= totalDays {
                if days[scalpDay - 1].activities.count < 2 {
                    days[scalpDay - 1].activities.append(.scalpCare)
                }
                scalpDay += scalpInterval
            }
        }

        var heatFreeDay = 2
        while heatFreeDay <= totalDays {
            if days[heatFreeDay - 1].activities.isEmpty {
                days[heatFreeDay - 1].activities.append(.heatFree)
            }
            heatFreeDay += 4
        }

        var protectDay = 7
        while protectDay <= totalDays {
            if days[protectDay - 1].activities.count < 2 {
                days[protectDay - 1].activities.append(.protectiveStyle)
            }
            protectDay += 7
        }

        let trimDay = min(15, totalDays)
        days[trimDay - 1].activities.append(.trim)

        return days
    }
}
