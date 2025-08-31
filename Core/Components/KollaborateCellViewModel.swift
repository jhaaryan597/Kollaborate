import SwiftUI
import Supabase
import Combine

@MainActor
class KollaborateCellViewModel: ObservableObject {
    @Published var kollaborate: Kollaborate
    @Published var didRepost: Bool = false
    @Published var showRepostSheet = false
    @Published var showShareSheet = false
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
        Task { 
            try await checkIfUserLikedKollaborate()
            try await checkIfUserReposted()
        }
    }
    
    func like() async throws {
        try await KollaborateService.shared.likeKollaborate(kollaborate)
        self.kollaborate.likes += 1
        self.kollaborate.didLike = true
    }
    
    func unlike() async throws {
        try await KollaborateService.shared.unlikeKollaborate(kollaborate)
        self.kollaborate.likes -= 1
        self.kollaborate.didLike = false
    }
    
    func checkIfUserLikedKollaborate() async throws {
        self.kollaborate.didLike = try await KollaborateService.checkIfUserLikedKollaborate(kollaborate)
    }
    
    func checkIfUserReposted() async throws {
        self.didRepost = try await RepostService.checkIfUserReposted(kollaborate)
    }
    
    func repost() async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        
        let repost = Repost(
            id: UUID().uuidString,
            originalPostId: kollaborate.id,
            repostedByUserId: uid
        )
        
        try await RepostService.createRepost(repost)
        self.didRepost = true
        self.kollaborate.repostsCount = (self.kollaborate.repostsCount ?? 0) + 1
    }
    
    func unrepost() async throws {
        // Find the repost and delete it
        let reposts = try await RepostService.fetchUserReposts(userId: AuthService.shared.currentUser?.id ?? "")
        if let repost = reposts.first(where: { $0.originalPostId == kollaborate.id }) {
            try await RepostService.deleteRepost(repostId: repost.id, originalPostId: kollaborate.id)
            self.didRepost = false
            self.kollaborate.repostsCount = (self.kollaborate.repostsCount ?? 0) - 1
        }
    }
    
    func share() {
        showShareSheet = true
    }
}
