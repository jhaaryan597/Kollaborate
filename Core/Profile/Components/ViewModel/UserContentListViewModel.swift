import Foundation

class UserContentListViewModel: ObservableObject {
    @Published var kollaborates = [Kollaborate]()
    @Published var responses = [Kollaborate]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task { 
            try await fetchUserKollaborates()
            try await fetchUserResponses()
        }
    }
    
    @MainActor
    func fetchUserKollaborates() async throws {
        self.kollaborates = try await KollaborateService.fetchUserKollaborates(uid: user.id)
        
        for i in 0 ..< kollaborates.count {
            kollaborates[i].user = self.user
        }
    }
    
    @MainActor
    func fetchUserResponses() async throws {
        self.responses = try await KollaborateService.fetchUserResponses(uid: user.id)
        
        for i in 0 ..< responses.count {
            responses[i].user = self.user
        }
    }
}
