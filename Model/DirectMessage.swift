import Foundation

public struct DirectMessage: Identifiable, Codable, Hashable {
    public let id: String
    public let senderId: String
    public let receiverId: String
    public let messageText: String
    public let isRead: Bool
    public let createdAt: Date
    
    public var sender: User?
    public var receiver: User?
    
    public init(id: String, senderId: String, receiverId: String, messageText: String, isRead: Bool = false, createdAt: Date = Date(), sender: User? = nil, receiver: User? = nil) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.messageText = messageText
        self.isRead = isRead
        self.createdAt = createdAt
        self.sender = sender
        self.receiver = receiver
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case messageText = "message_text"
        case isRead = "is_read"
        case createdAt = "created_at"
        case sender
        case receiver
    }
}
