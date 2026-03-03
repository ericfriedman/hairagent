import SwiftUI

struct SelectedHairColor: Equatable, Codable {
    let red: Double
    let green: Double
    let blue: Double
    let label: String

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }
}

struct HairColorStop {
    let position: Double
    let red: Double
    let green: Double
    let blue: Double
    let label: String
}

enum HairColorGradient {
    static let stops: [HairColorStop] = [
        // Natural hair colors
        HairColorStop(position: 0.00, red: 0.07, green: 0.06, blue: 0.06, label: "Black"),
        HairColorStop(position: 0.08, red: 0.26, green: 0.15, blue: 0.07, label: "Dark Brown"),
        HairColorStop(position: 0.16, red: 0.60, green: 0.20, blue: 0.10, label: "Auburn"),
        HairColorStop(position: 0.24, red: 0.48, green: 0.30, blue: 0.15, label: "Medium Brown"),
        HairColorStop(position: 0.32, red: 0.65, green: 0.45, blue: 0.25, label: "Light Brown"),
        HairColorStop(position: 0.40, red: 0.73, green: 0.60, blue: 0.35, label: "Dark Blonde"),
        HairColorStop(position: 0.48, red: 0.90, green: 0.78, blue: 0.50, label: "Blonde"),
        HairColorStop(position: 0.56, red: 0.94, green: 0.92, blue: 0.86, label: "Platinum"),
        // Rainbow / fun colors
        HairColorStop(position: 0.64, red: 1.00, green: 0.41, blue: 0.71, label: "Pink"),
        HairColorStop(position: 0.72, red: 0.90, green: 0.10, blue: 0.10, label: "Red"),
        HairColorStop(position: 0.78, red: 1.00, green: 0.55, blue: 0.00, label: "Orange"),
        HairColorStop(position: 0.84, red: 1.00, green: 0.87, blue: 0.00, label: "Yellow"),
        HairColorStop(position: 0.90, red: 0.00, green: 0.75, blue: 0.35, label: "Green"),
        HairColorStop(position: 0.95, red: 0.15, green: 0.40, blue: 0.95, label: "Blue"),
        HairColorStop(position: 1.00, red: 0.55, green: 0.15, blue: 0.80, label: "Purple"),
    ]

    static var swiftUIGradient: LinearGradient {
        LinearGradient(
            stops: stops.map { Gradient.Stop(color: Color(red: $0.red, green: $0.green, blue: $0.blue), location: $0.position) },
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static func interpolate(at position: Double) -> SelectedHairColor {
        let pos = max(0, min(1, position))

        var lower = stops[0]
        var upper = stops[stops.count - 1]

        for i in 0..<(stops.count - 1) {
            if pos >= stops[i].position && pos <= stops[i + 1].position {
                lower = stops[i]
                upper = stops[i + 1]
                break
            }
        }

        let range = upper.position - lower.position
        let t = range > 0 ? (pos - lower.position) / range : 0

        return SelectedHairColor(
            red: lower.red + (upper.red - lower.red) * t,
            green: lower.green + (upper.green - lower.green) * t,
            blue: lower.blue + (upper.blue - lower.blue) * t,
            label: closestLabel(at: pos)
        )
    }

    static func closestLabel(at position: Double) -> String {
        let pos = max(0, min(1, position))
        var closest = stops[0]
        var minDist = Double.infinity
        for stop in stops {
            let dist = abs(stop.position - pos)
            if dist < minDist {
                minDist = dist
                closest = stop
            }
        }
        return closest.label
    }
}
