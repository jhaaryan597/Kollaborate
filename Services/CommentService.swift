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
        let comments: [Comment] = try await client
            .from("post_comments")
            .select("*, user:users(*)")
            .eq("post_id", value: postId)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return comments
    }
    
    func postComment(_ commentText: String, forPostId postId: String, userId: String) async throws {
        let comment = Comment(id: UUID(), postId: postId, userId: UUID(uuidString: userId)!, commentText: commentText, createdAt: Date())
        
        try await client
            .from("post_comments")
            .insert(comment)
            .execute()
        
        let params = IncrementParams(post_id: postId, increment_amount: 1)
        try await client.rpc("increment_comments", params: params).execute()
        newCommentSubject.send()
    }
    
    func deleteComment(withId commentId: UUID, postId: String) async throws {
        try await client
            .from("post_comments")
            .delete()
            .eq("id", value: commentId)
            .execute()
        
        let params = IncrementParams(post_id: postId, increment_amount: -1)
        try await client.rpc("increment_comments", params: params).execute()
    }
}
