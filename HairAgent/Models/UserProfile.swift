import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var hairColorRed: Double?
    var hairColorGreen: Double?
    var hairColorBlue: Double?
    var hairColorLabel: String?
    var hairTextureRaw: String?
    var hairGoalRaws: [String]

    init(name: String) {
        self.name = name
        self.hairGoalRaws = []
    }

    var selectedHairColor: SelectedHairColor? {
        get {
            guard let r = hairColorRed, let g = hairColorGreen, let b = hairColorBlue, let label = hairColorLabel else {
                return nil
            }
            return SelectedHairColor(red: r, green: g, blue: b, label: label)
        }
        set {
            hairColorRed = newValue?.red
            hairColorGreen = newValue?.green
            hairColorBlue = newValue?.blue
            hairColorLabel = newValue?.label
        }
    }

    var hairTexture: HairTexture? {
        get { hairTextureRaw.flatMap { HairTexture(rawValue: $0) } }
        set { hairTextureRaw = newValue?.rawValue }
    }

    var hairGoals: [HairGoal] {
        get { hairGoalRaws.compactMap { HairGoal(rawValue: $0) } }
        set { hairGoalRaws = newValue.map(\.rawValue) }
    }
}
