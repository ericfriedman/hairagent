import Foundation

struct HairSolution: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let ingredients: [String]
    let steps: [String]
    let helpsWith: [HairTexture]
    let goalTags: [HairGoal]
    let solutionType: SolutionType
    let defaultFrequency: String
    let frequencyByTexture: [HairTexture: String]
    let overuseWarning: String

    func matches(texture: HairTexture, goals: [HairGoal]) -> Bool {
        let textureMatch = helpsWith.contains(texture)
        let goalMatch = goalTags.contains(where: { goals.contains($0) })
        return textureMatch || goalMatch
    }

    func personalizedFrequency(for texture: HairTexture) -> String {
        frequencyByTexture[texture] ?? defaultFrequency
    }
}
