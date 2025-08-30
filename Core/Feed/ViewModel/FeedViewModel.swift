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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("NewPost"), object: nil, queue: .main) { [weak self] _ in
            Task { try await self?.fetchKollaborates() }
        }
    }
    
    func fetchKollaborates() async throws {
        // Fetch all kollaborates first
        var fetchedKollaborates = try await KollaborateService.fetchKollaborates()
        
        // Fetch user data for each kollaborate
        for i in 0 ..< fetchedKollaborates.count {
            let kollaborate = fetchedKollaborates[i]
            let ownerUid = kollaborate.ownerUid
            let kollaborateUser = try await UserService.fetchUser(withUid: ownerUid)
            fetchedKollaborates[i].user = kollaborateUser
        }
        
        // Display all fetched kollaborates without filtering
        self.kollaborates = fetchedKollaborates
    }
}
