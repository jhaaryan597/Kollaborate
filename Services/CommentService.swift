import Foundation
import Supabase
import Combine

class CommentService {
    static let shared = CommentService()
    private let client = supabase
    let newCommentSubject = PassthroughSubject<Void, Never>()
    
    private struct IncrementParams: Codable {
        let post_id: String
        let increment_amount: Int
    }
    
    func fetchComments(forPostId postId: String) async throws -> [Comment] {
        print("🔍 Fetching comments for post: \(postId)")
        
        let comments: [Comment] = try await client
            .from("post_comments")
            .select("*, users(*)")
            .eq("post_id", value: postId)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        print("✅ Fetched \(comments.count) comments successfully")
        return comments
    }
    
    func postComment(_ commentText: String, forPostId postId: String, userId: String) async throws {
        print("📝 Posting comment: '\(commentText)' for post: \(postId)")
        
        guard let userUUID = UUID(uuidString: userId) else {
            throw NSError(domain: "CommentServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user UUID"])
        }
        
        let comment = Comment(
            id: UUID(), 
            postId: postId, 
            userId: userUUID, 
            commentText: commentText, 
            createdAt: Date()
        )
        
        print("🌐 Inserting comment into database...")
        try await client
            .from("post_comments")
            .insert(comment)
            .execute()
        
        print("📈 Incrementing comment count...")
        let params = IncrementParams(post_id: postId, increment_amount: 1)
        try await client.rpc("increment_comments", params: params).execute()
        
        print("✅ Comment posted successfully")
        newCommentSubject.send()
    }
    
    func deleteComment(withId commentId: UUID, postId: String) async throws {
        print("🗑️ Deleting comment: \(commentId)")
        
        try await client
            .from("post_comments")
            .delete()
            .eq("id", value: commentId)
            .execute()
        
        print("📉 Decrementing comment count...")
        let params = IncrementParams(post_id: postId, increment_amount: -1)
        try await client.rpc("increment_comments", params: params).execute()
        
        print("✅ Comment deleted successfully")
    }
}
