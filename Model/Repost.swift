import Foundation

public struct Repost: Identifiable, Codable, Hashable {
    public let id: String
    public let originalPostId: String
    public let repostedByUserId: String
    public let repostText: String?
    public let createdAt: Date
    
    public var originalPost: Kollaborate?
    public var repostedByUser: User?
    
    public init(id: String, originalPostId: String, repostedByUserId: String, repostText: String? = nil, createdAt: Date = Date(), originalPost: Kollaborate? = nil, repostedByUser: User? = nil) {
        self.id = id
        self.originalPostId = originalPostId
        self.repostedByUserId = repostedByUserId
        self.repostText = repostText
        self.createdAt = createdAt
        self.originalPost = originalPost
        self.repostedByUser = repostedByUser
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalPostId = "original_post_id"
        case repostedByUserId = "reposted_by_user_id"
        case repostText = "repost_text"
        case createdAt = "created_at"
        case originalPost
        case repostedByUser
    }
}
