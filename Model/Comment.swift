import Foundation

struct Comment: Identifiable, Codable, Hashable {
    let id: UUID
    let postId: String
    let userId: UUID
    let commentText: String
    let createdAt: Date
    var parentCommentId: UUID?
    
    var user: User?
    var replies: [Comment]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postId = "post_id"
        case userId = "user_id"
        case commentText = "comment_text"
        case createdAt = "created_at"
        case parentCommentId = "parent_comment_id"
        case user
        case replies
    }
}
