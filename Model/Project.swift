import Foundation

struct Project: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let ownerId: String
    var memberIds: [String]
    var tasks: [Task]
}

struct Task: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var isCompleted: Bool
    var assignedToId: String?
}
