import Foundation

struct Channel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let isPrivate: Bool
    let createdBy: String
    var members: [String]
}
