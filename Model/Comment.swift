import Foundation

struct Comment: Identifiable, Codable {
    let id: UUID
    let postId: String
    let userId: UUID
    let commentText: String
    let createdAt: Date
    
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postId = "post_id"
        case userId = "user_id"
        case commentText = "comment_text"
        case createdAt = "created_at"
        case user
    }
}
