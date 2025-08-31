import Foundation
import Supabase
import Combine

public struct DirectMessageService {
    
    public static let shared = DirectMessageService()
    public let messageUpdateSubject = PassthroughSubject<Void, Never>()
    
    private struct EncodableMessage: Encodable {
        let id: String
        let sender_id: String
        let receiver_id: String
        let message_text: String
        let is_read: Bool
        let created_at: String
    }
    
    public static func sendMessage(_ message: DirectMessage) async throws {
        let encodableMessage = EncodableMessage(
            id: message.id,
            sender_id: message.senderId,
            receiver_id: message.receiverId,
            message_text: message.messageText,
            is_read: message.isRead,
            created_at: message.createdAt.ISO8601Format()
        )
        
        try await supabase.database
            .from("direct_messages")
            .insert(encodableMessage)
            .execute()
        
        DirectMessageService.shared.messageUpdateSubject.send()
    }
    
    public static func fetchConversation(withUserId userId: String) async throws -> [DirectMessage] {
        guard let currentUserId = AuthService.shared.currentUser?.id else { return [] }
        
        let messages: [DirectMessage] = try await supabase.database
            .from("direct_messages")
            .select("*, sender:users(*), receiver:users(*)")
            .or("sender_id.eq.\(currentUserId),receiver_id.eq.\(currentUserId)")
            .or("sender_id.eq.\(userId),receiver_id.eq.\(userId)")
            .order("created_at", ascending: true)
            .execute()
            .value
        
        return messages
    }
    
    public static func markMessageAsRead(messageId: String) async throws {
        try await supabase.database
            .from("direct_messages")
            .update(["is_read": true])
            .eq("id", value: messageId)
            .execute()
        
        DirectMessageService.shared.messageUpdateSubject.send()
    }
    
    public static func fetchUnreadMessageCount() async throws -> Int {
        guard let currentUserId = AuthService.shared.currentUser?.id else { return 0 }
        
        let count: Int = try await supabase.database
            .from("direct_messages")
            .select("*", head: true, count: .exact)
            .eq("receiver_id", value: currentUserId)
            .eq("is_read", value: false)
            .execute()
            .count ?? 0
        
        return count
    }
    
    public static func deleteMessage(messageId: String) async throws {
        try await supabase.database
            .from("direct_messages")
            .delete()
            .eq("id", value: messageId)
            .execute()
        
        DirectMessageService.shared.messageUpdateSubject.send()
    }
}
