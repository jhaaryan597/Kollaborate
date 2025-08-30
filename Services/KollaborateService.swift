import Foundation
import Supabase

public struct KollaborateService {
    
    private struct EncodableKollaborate: Encodable {
        let id: String
        let owner_uid: String
        let caption: String
        let timestamp: String
        let likes: Int
        let attachment_url: String?
        let type: String?
    }

    public static func uploadKollaborate(_ kollaborate: Kollaborate) async throws {
        let encodableKollaborate = EncodableKollaborate(
            id: kollaborate.id,
            owner_uid: kollaborate.ownerUid,
            caption: kollaborate.caption,
            timestamp: kollaborate.timestamp.ISO8601Format(),
            likes: kollaborate.likes,
            attachment_url: kollaborate.attachmentURL,
            type: kollaborate.type?.rawValue
        )
        
        try await supabase.database
            .from("kollaborates")
            .insert(encodableKollaborate)
            .execute()
    }
    
    public static func fetchKollaborates() async throws -> [Kollaborate] {
        let kollaborates: [Kollaborate] = try await supabase.database
            .from("kollaborates")
            .select()
            .order("timestamp", ascending: false)
            .execute()
            .value
        
        return kollaborates
    }
    
    private struct PostLike: Codable {
        let post_id: String
        let user_id: String
    }
    
    private struct IncrementParams: Codable {
        let post_id: String
        let increment_amount: Int
    }

    public static func likeKollaborate(_ kollaborate: Kollaborate) async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        
        let postLike = PostLike(post_id: kollaborate.id, user_id: uid)
        try await supabase.database.from("post_likes").insert(postLike).execute()
        
        let params = IncrementParams(post_id: kollaborate.id, increment_amount: 1)
        try await supabase.database.rpc("increment_likes", params: params).execute()
    }
    
    public static func unlikeKollaborate(_ kollaborate: Kollaborate) async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        
        try await supabase.database.from("post_likes").delete().eq("post_id", value: kollaborate.id).eq("user_id", value: uid).execute()
        
        let params = IncrementParams(post_id: kollaborate.id, increment_amount: -1)
        try await supabase.database.rpc("increment_likes", params: params).execute()
    }
    
    public static func checkIfUserLikedKollaborate(_ kollaborate: Kollaborate) async throws -> Bool {
        guard let uid = AuthService.shared.currentUser?.id else { return false }
        
        do {
            let _: PostLike = try await supabase.database.from("post_likes").select().eq("post_id", value: kollaborate.id).eq("user_id", value: uid).single().execute().value
            return true
        } catch {
            return false
        }
    }
    
    public static func fetchUserKollaborates(uid: String) async throws -> [Kollaborate] {
        let kollaborates: [Kollaborate] = try await supabase.database
            .from("kollaborates")
            .select()
            .eq("ownerUid", value: uid)
            .order("timestamp", ascending: false)
            .execute()
            .value
            
        return kollaborates
    }
}
