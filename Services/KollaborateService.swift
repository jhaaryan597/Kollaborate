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
