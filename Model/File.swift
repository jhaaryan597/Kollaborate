import Foundation

struct File: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let type: String
    let url: String
}
