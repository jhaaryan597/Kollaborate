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
    }
    
    func unrepost() async throws {
        // Find the repost and delete it
        let reposts = try await RepostService.fetchUserReposts(userId: AuthService.shared.currentUser?.id ?? "")
        if let repost = reposts.first(where: { $0.originalPostId == kollaborate.id }) {
            try await RepostService.deleteRepost(repostId: repost.id, originalPostId: kollaborate.id)
            self.didRepost = false
        }
    }
    
    func share() {
        showShareSheet = true
    }
}

struct KollaborateCell: View {
    @StateObject var viewModel: KollaborateCellViewModel
    
    init(kollaborate: Kollaborate) {
        self._viewModel = StateObject(wrappedValue: KollaborateCellViewModel(kollaborate: kollaborate))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User Info
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(user: viewModel.kollaborate.user, size: .small)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.kollaborate.user?.username ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("PrimaryText"))
                    
                    Text(viewModel.kollaborate.timestamp.timestampString())
                        .font(.system(size: 12))
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Spacer()
                
                Button {
                    // More options
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            
            // Caption
            Text(viewModel.kollaborate.caption)
                .font(.system(size: 14))
                .foregroundColor(Color("PrimaryText"))
                .multilineTextAlignment(.leading)
            
            // Action Buttons
            HStack(spacing: 24) {
                Button {
                    Task {
                        if viewModel.kollaborate.didLike == true {
                            try await viewModel.unlike()
                        } else {
                            try await viewModel.like()
                        }
                    }
                } label: {
                    Image(systemName: viewModel.kollaborate.didLike == true ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.kollaborate.didLike == true ? .red : Color("SecondaryText"))
                }
                
                NavigationLink(destination: CommentView(kollaborate: viewModel.kollaborate)) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                            .foregroundColor(Color("SecondaryText"))
                        
                        Text("\(viewModel.kollaborate.commentsCount ?? 0)")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryText"))
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: viewModel.didRepost ? "arrow.rectanglepath.fill" : "arrow.rectanglepath")
                        .foregroundColor(viewModel.didRepost ? .green : Color("SecondaryText"))
                    
                    Text("\(viewModel.kollaborate.repostsCount ?? 0)")
                        .font(.caption)
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    Task {
                        if viewModel.didRepost {
                            try await viewModel.unrepost()
                        } else {
                            try await viewModel.repost()
                        }
                    }
                } label: {
                    Image(systemName: viewModel.didRepost ? "arrow.rectanglepath.fill" : "arrow.rectanglepath")
                        .foregroundColor(viewModel.didRepost ? .green : Color("SecondaryText"))
                }
                
                Button {
                    viewModel.share()
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(activityItems: [viewModel.kollaborate.caption])
        }
    }
}

struct KollaborateCell_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateCell(kollaborate: dev.kollaborate)
    }
}
