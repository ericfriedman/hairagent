import Foundation

struct HairSolution: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let ingredients: [String]
    let steps: [String]
    let helpsWith: [HairTexture]
    let goalTags: [HairGoal]

    func matches(texture: HairTexture, goals: [HairGoal]) -> Bool {
        let textureMatch = helpsWith.contains(texture)
        let goalMatch = goalTags.contains(where: { goals.contains($0) })
        return textureMatch || goalMatch
    }
}
