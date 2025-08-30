import SwiftUI

@MainActor
class KollaborateCellViewModel: ObservableObject {
    @Published var kollaborate: Kollaborate
    
    init(kollaborate: Kollaborate) {
        self.kollaborate = kollaborate
        Task { try await checkIfUserLikedKollaborate() }
    }
    
    func like() async throws {
        try await KollaborateService.likeKollaborate(kollaborate)
        self.kollaborate.likes += 1
        self.kollaborate.didLike = true
    }
    
    func unlike() async throws {
        try await KollaborateService.unlikeKollaborate(kollaborate)
        self.kollaborate.likes -= 1
        self.kollaborate.didLike = false
    }
    
    func checkIfUserLikedKollaborate() async throws {
        self.kollaborate.didLike = try await KollaborateService.checkIfUserLikedKollaborate(kollaborate)
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
                
                Button {
                    // Comment
                } label: {
                    Image(systemName: "bubble.right")
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    // Repost
                } label: {
                    Image(systemName: "arrow.rectanglepath")
                        .foregroundColor(Color("SecondaryText"))
                }
                
                Button {
                    // Share
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
    }
}

struct KollaborateCell_Previews: PreviewProvider {
    static var previews: some View {
        KollaborateCell(kollaborate: dev.kollaborate)
    }
}
