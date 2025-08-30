import Foundation
import Supabase

class UserService {
    var currentUser: User? {
        return AuthService.shared.currentUser
    }
    
    static let shared = UserService()
    
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
        // This now does nothing, as the user is managed by AuthService
    }
    
    @MainActor
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = currentUser?.id else { return }
        
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
            .eq("id", value: currentUid)
            .execute()
        
        AuthService.shared.currentUser?.profileImageUrl = imageUrl
    }
}
