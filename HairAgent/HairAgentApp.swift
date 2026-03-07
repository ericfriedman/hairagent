import SwiftUI
import SwiftData

@main
struct HairAgentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserProfile.self)
    }
}
