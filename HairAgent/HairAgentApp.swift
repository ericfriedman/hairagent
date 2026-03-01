import SwiftUI
import SwiftData

struct HairAgentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserProfile.self)
    }
}
