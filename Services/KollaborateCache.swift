import Foundation
import Combine

@MainActor
class KollaborateCache: ObservableObject {
    @Published var kollaborates = [Kollaborate]()
    static let shared = KollaborateCache()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Listen for new posts
        NotificationCenter.default.publisher(for: NSNotification.Name("NewPost"))
            .sink { [weak self] _ in self?.fetchKollaborates() }
            .store(in: &cancellables)

        // Listen for new comments
        CommentService.shared.newCommentSubject
            .sink { [weak self] in self?.fetchKollaborates() }
            .store(in: &cancellables)
            
        // Listen for new likes
        KollaborateService.shared.newLikeSubject
            .sink { [weak self] in self?.fetchKollaborates() }
            .store(in: &cancellables)
    }

    func fetchKollaborates() {
        Task {
            do {
                var fetchedKollaborates = try await KollaborateService.fetchKollaborates()
                
                for i in 0 ..< fetchedKollaborates.count {
                    let kollaborate = fetchedKollaborates[i]
                    let ownerUid = kollaborate.ownerUid
                    let kollaborateUser = try await UserService.fetchUser(withUid: ownerUid)
                    fetchedKollaborates[i].user = kollaborateUser
                }
                
                self.kollaborates = fetchedKollaborates
            } catch {
                print("DEBUG: Failed to fetch kollaborates with error: \(error.localizedDescription)")
            }
        }
    }
}
