import Foundation
import Supabase
import Combine

public struct RepostService {
    
    public static let shared = RepostService()
    public let repostUpdateSubject = PassthroughSubject<Void, Never>()
    
    private struct EncodableRepost: Encodable {
        let id: String
        let original_post_id: String
        let reposted_by_user_id: String
        let repost_text: String?
        let created_at: String
    }
    
    private struct IncrementRepostsParams: Encodable {
        let post_id_param: String
        let increment_amount: Int
    }
    
    public static func createRepost(_ repost: Repost) async throws {
        let encodableRepost = EncodableRepost(
            id: repost.id,
            original_post_id: repost.originalPostId,
            reposted_by_user_id: repost.repostedByUserId,
            repost_text: repost.repostText,
            created_at: repost.createdAt.ISO8601Format()
        )
        
        try await supabase.database
            .from("post_reposts")
            .insert(encodableRepost)
            .execute()
        
        // Increment repost count
        let params = IncrementRepostsParams(post_id_param: repost.originalPostId, increment_amount: 1)
        try await supabase.database.rpc("increment_reposts", params: params).execute()
        
        RepostService.shared.repostUpdateSubject.send()
    }
    
    public static func deleteRepost(repostId: String, originalPostId: String) async throws {
        try await supabase.database
            .from("post_reposts")
            .delete()
            .eq("id", value: repostId)
            .execute()
        
        // Decrement repost count
        let params = IncrementRepostsParams(post_id_param: originalPostId, increment_amount: -1)
        try await supabase.database.rpc("increment_reposts", params: params).execute()
        
        RepostService.shared.repostUpdateSubject.send()
    }
    
    public static func checkIfUserReposted(_ kollaborate: Kollaborate) async throws -> Bool {
        guard let uid = AuthService.shared.currentUser?.id else { return false }
        
        do {
            let _: Repost = try await supabase.database
                .from("post_reposts")
                .select()
                .eq("original_post_id", value: kollaborate.id)
                .eq("reposted_by_user_id", value: uid)
                .single()
                .execute()
                .value
            return true
        } catch {
            return false
        }
    }
    
    public static func fetchRepostsForPost(postId: String) async throws -> [Repost] {
        let reposts: [Repost] = try await supabase.database
            .from("post_reposts")
            .select("*, original_post:kollaborates(*), reposted_by_user:users(*)")
            .eq("original_post_id", value: postId)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return reposts
    }
    
    public static func fetchUserReposts(userId: String) async throws -> [Repost] {
        let reposts: [Repost] = try await supabase.database
            .from("post_reposts")
            .select("*, original_post:kollaborates(*), reposted_by_user:users(*)")
            .eq("reposted_by_user_id", value: userId)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return reposts
    }
}
