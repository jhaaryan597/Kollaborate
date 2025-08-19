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
    func login(withEmail email: String, password: String) async -> Result<Void, Error> {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            await loadUserData()
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String, organizationId: String, role: UserRole) async -> Result<Void, Error> {
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            
            let user = User(id: result.user.id.uuidString, fullname: fullname, email: email, username: username, organizationId: organizationId, role: role)
            
            try await supabase.database
                .from("users")
                .insert(user)
                .execute()
            
            await loadUserData()
            return .success(())
        } catch {
            return .failure(error)
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
