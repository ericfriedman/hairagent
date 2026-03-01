import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String

    init(name: String) {
        self.name = name
    }
}
