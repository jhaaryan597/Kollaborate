import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var kollaborates = [Kollaborate]()
    
    init() {
        Task { try await fetchKollaborates() }
    }
    
    func fetchKollaborates() async throws {
        guard let organizationId = AuthService.shared.currentUser?.organizationId else { return }
        self.kollaborates = try await KollaborateService.fetchKollaborates().filter { $0.user?.organizationId == organizationId }
        try await fetchUserDataForKollaborates()
    }
    
    private func fetchUserDataForKollaborates() async throws {
        for i in 0 ..< kollaborates.count {
            let kollaborate = kollaborates[i]
            let ownerUid = kollaborate.ownerUid
            let kollaborateUser = try await UserService.fetchUser(withUid: ownerUid)
            
            kollaborates[i].user = kollaborateUser
        }
    }
}
