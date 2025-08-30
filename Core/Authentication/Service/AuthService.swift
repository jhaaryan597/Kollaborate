import Foundation
import Supabase

class AuthService: ObservableObject {
    
    @Published var session: Session?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    private var authStateTask: Task<Void, Never>? = nil
    
    init() {
        authStateTask = Task {
            for await (event, session) in supabase.auth.authStateChanges {
                await MainActor.run {
                    switch event {
                    case .signedIn:
                        self.session = session
                        Task { await self.loadUserData() }
                    case .signedOut:
                        self.session = nil
                        self.currentUser = nil
                    default:
                        break
                    }
                }
            }
        }
    }
    
    @MainActor
    private func loadUserData() async {
        guard let session = session else { return }
        do {
            self.currentUser = try await UserService.fetchUser(withUid: session.user.id.uuidString)
        } catch {
            print("DEBUG: Error loading user data: \(error.localizedDescription)")
            self.currentUser = nil
        }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async -> Result<Void, Error> {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String, role: UserRole) async -> Result<Void, Error> {
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            
            let user = User(id: result.user.id.uuidString, fullname: fullname, email: email, username: username, role: role)
            
            try await supabase.database
                .from("users")
                .insert(user)
                .execute()
            
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
        } catch {
            print("DEBUG: Error signing out: \(error.localizedDescription)")
        }
    }
}
