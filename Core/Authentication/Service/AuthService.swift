import Foundation
import Supabase

class AuthService: ObservableObject {
    
    @Published var session: Session?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init() {
        Task {
            await loadUserData()
        }
    }
    
    @MainActor
    func loadUserData() async {
        do {
            self.session = try await supabase.auth.session
            guard let session = session else { return }
            self.currentUser = try await UserService.fetchUser(withUid: session.user.id.uuidString)
        } catch {
            print("DEBUG: Error loading user data: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            // On successful login, fetch the user profile
            await loadUserData()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    private struct EncodableUser: Encodable {
        let id: String
        let fullname: String
        let email: String
        let username: String
        let organization_id: String?
        let role: String?
    }

    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String, organizationId: String, role: UserRole) async throws {
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            
            let user = User(id: result.user.id.uuidString, fullname: fullname, email: email, username: username, organizationId: organizationId, role: role)
            let encodableUser = EncodableUser(
                id: user.id,
                fullname: user.fullname,
                email: user.email,
                username: user.username,
                organization_id: user.organizationId,
                role: user.role?.rawValue
            )
            
            try await supabase.database
                .from("users")
                .insert(encodableUser)
                .execute()
            
            await loadUserData()
        } catch {
            throw error
        }
    }
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.currentUser = nil
            UserService.shared.reset()
        } catch {
            print("DEBUG: Error signing out: \(error.localizedDescription)")
        }
    }
    
}
