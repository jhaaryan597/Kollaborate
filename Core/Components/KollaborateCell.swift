import SwiftUI
import Supabase
import Combine

@MainActor
class KollaborateCellViewModel: ObservableObject {
    @Published var kollaborate: Kollaborate
    @Published var showShareSheet = false
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
        Task { 
            try await checkIfUserLikedKollaborate()
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
    
    func share() {
        showShareSheet = true
    }
    
    func deletePost() async throws {
        try await KollaborateService.shared.deleteKollaborate(kollaborate)
    }
}

struct KollaborateCell: View {
    @StateObject var viewModel: KollaborateCellViewModel
    @State private var showDeleteConfirmation = false
    
    init(kollaborate: Kollaborate) {
        self._viewModel = StateObject(wrappedValue: KollaborateCellViewModel(kollaborate: kollaborate))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Reduced spacing
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
                
                Menu {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("SecondaryText"))
                }
            }
            
            // Caption and Action Buttons
            HStack(alignment: .bottom) {
                Text(viewModel.kollaborate.caption)
                    .font(.system(size: 14))
                    .foregroundColor(Color("PrimaryText"))
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack(spacing: 16) {
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
                }
            }
        }
        .padding(12) // Reduced padding
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareSheet(activityItems: [viewModel.kollaborate.caption])
        }
        .alert("Delete Post", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                Task {
                    try await viewModel.deletePost()
                }
            }
        } message: {
            Text("Are you sure you want to delete this post? This action cannot be undone.")
        }
    }
}

struct KollaborateCell_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateCell(kollaborate: dev.kollaborate)
    }
}
