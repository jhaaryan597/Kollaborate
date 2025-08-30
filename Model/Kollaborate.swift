import Foundation

public enum ThreadType: String, Codable, CaseIterable {
    case standard
    case event
    case projectUpdate
}

public struct Kollaborate: Identifiable, Codable, Hashable {
    public let id: String
    public let ownerUid: String
    public let caption: String
    public let timestamp: Date
    public var likes: Int
    public var attachmentURL: String?
    public var type: ThreadType?
    
    public var user: User?
    public var didLike: Bool? = false
    
    public init(id: String, ownerUid: String, caption: String, timestamp: Date, likes: Int, attachmentURL: String? = nil, type: ThreadType? = nil, user: User? = nil) {
        self.id = id
        self.ownerUid = ownerUid
        self.caption = caption
        self.timestamp = timestamp
        self.likes = likes
        self.attachmentURL = attachmentURL
        self.type = type
        self.user = user
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerUid = "owner_uid"
        case caption
        case timestamp
        case likes
        case attachmentURL = "attachment_url"
        case type
        case user
        case didLike
    }
}
