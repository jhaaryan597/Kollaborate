import Foundation
import Supabase

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        let currentUid = try await supabase.auth.session.user.id
        
        let user: User = try await supabase.database
            .from("users")
            .select()
            .eq("id", value: currentUid.uuidString)
            .single()
            .execute()
            .value
        
        self.currentUser = user
    }
    
    static func fetchUsers() async throws -> [User] {
        let currentUid = try await supabase.auth.session.user.id
        
        let users: [User] = try await supabase.database
            .from("users")
            .select()
            .execute()
            .value
        
        return users.filter({ $0.id != currentUid.uuidString })
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let user: User = try await supabase.database
            .from("users")
            .select()
            .eq("id", value: uid)
            .single()
            .execute()
            .value
            
        return user
    }
    
    func reset() {
        self.currentUser = nil
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        let currentUid = try await supabase.auth.session.user.id
        
        let updatedUser = User(
            id: currentUser!.id,
            fullname: currentUser!.fullname,
            email: currentUser!.email,
            username: currentUser!.username,
            profileImageUrl: imageUrl
        )
        
        try await supabase.database
            .from("users")
            .update(updatedUser)
            .eq("id", value: currentUid.uuidString)
            .execute()
        
        self.currentUser?.profileImageUrl = imageUrl
    }
}
