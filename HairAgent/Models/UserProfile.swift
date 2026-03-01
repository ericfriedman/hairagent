import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var hairColorRaw: String?
    var hairTextureRaw: String?
    var hairGoalRaws: [String]

    init(name: String) {
        self.name = name
        self.hairGoalRaws = []
    }

    var hairColor: HairColor? {
        get { hairColorRaw.flatMap { HairColor(rawValue: $0) } }
        set { hairColorRaw = newValue?.rawValue }
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
