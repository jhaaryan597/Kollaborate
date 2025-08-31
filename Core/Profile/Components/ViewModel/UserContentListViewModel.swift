import Foundation

class UserContentListViewModel: ObservableObject {
    @Published var kollaborates = [Kollaborate]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserKollaborates() }
    }
    
    @MainActor
    func fetchUserKollaborates() async throws {
        self.kollaborates = try await KollaborateService.fetchUserKollaborates(uid: user.id)
        
        for i in 0 ..< kollaborates.count {
            kollaborates[i].user = self.user
        }
    }
}
