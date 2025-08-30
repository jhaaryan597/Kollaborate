import Foundation
import Combine

@MainActor
class FeedViewModel: ObservableObject {
    @Published var kollaborates = [Kollaborate]()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        AuthService.shared.$currentUser
            .sink { [weak self] user in
                guard user != nil else { return }
                Task { try await self?.fetchKollaborates() }
            }
            .store(in: &cancellables)
    }
    
    func fetchKollaborates() async throws {
        guard let organizationId = AuthService.shared.currentUser?.organizationId else { return }
        
        // Fetch all kollaborates first
        var fetchedKollaborates = try await KollaborateService.fetchKollaborates()
        
        // Fetch user data for each kollaborate
        for i in 0 ..< fetchedKollaborates.count {
            let kollaborate = fetchedKollaborates[i]
            let ownerUid = kollaborate.ownerUid
            let kollaborateUser = try await UserService.fetchUser(withUid: ownerUid)
            fetchedKollaborates[i].user = kollaborateUser
        }
        
        // Now, filter the kollaborates based on the organizationId
        self.kollaborates = fetchedKollaborates.filter { $0.user?.organizationId == organizationId }
    }
}
